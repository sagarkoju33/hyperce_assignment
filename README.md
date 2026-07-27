# Server-Driven UI (SDUI) — Flutter Assignment

A Flutter app that renders its entire UI — screens, forms, navigation, and
theming — from JSON returned by an API, rather than from hardcoded widget
trees. Built for the Flutter Developer technical assignment.

---

## 1. Project Setup

**Requirements:** Flutter 3.44+ (Dart 3.12+).

```bash
flutter pub get
flutter run
```

Run tests:

```bash
flutter test
```

No backend server needs to be started. See [Assumptions](#4-assumptions) below.

---

## 2. Architecture

```
lib/
├── core/                  # Cross-cutting utilities: theme, Result type, color/style parsing
├── network/                # ApiClient contract + Dio (real) and Mock implementations
├── models/                # ScreenConfig, WidgetConfig, ActionConfig — the JSON-parsing layer
├── repositories/           # ScreenRepository — single source of truth for fetching/caching screens
├── state/                  # Riverpod providers (DI root, screen fetch, form state, theme)
├── widgets/
│   ├── renderer/            # WidgetFactory (type -> widget dispatch), SduiRenderer, ActionHandler
│   └── components/          # One widget per supported JSON type (text, button, image, ...)
├── screens/                # DynamicScreen — the ONE screen class used for every backend route
└── routes/                  # AppRouter — generates routes for any route name, no hardcoded list
```

**Data flow:**

```
Backend JSON
   -> ApiClient (network I/O only)
   -> ScreenRepository (parsing, caching, error normalization -> Result<T>)
   -> Riverpod screenConfigProvider (async state)
   -> DynamicScreen (loading / error / data states)
   -> SduiRenderer -> WidgetFactory -> individual Sdui* widgets
```

Each layer only knows about the layer directly below it, which keeps the
system testable and lets any layer be swapped independently (e.g. mock API
for a real one, Riverpod for another state manager, one widget component for
a redesigned one).

### The rendering engine

`WidgetConfig` (in `models/widget_config.dart`) is a thin, recursive wrapper
around a widget's raw JSON node with typed, null-safe getters
(`text`, `action`, `children`, `child`, ...). It intentionally does **not**
have a subclass per widget type — that would mean touching the model every
time a new widget is added.

`WidgetFactory.build(WidgetConfig)` is the single dispatch point mapping a
`type` string to a Flutter widget. **Adding a new widget type is exactly two
steps:**

1. Create `widgets/components/sdui_<name>.dart`.
2. Add one `case '<name>':` in `widget_factory.dart`.

No other file changes. Container widgets (`column`, `row`, `card`) recurse
back into `WidgetFactory.build` for their children, so arbitrarily nested
trees "just work."

### Actions & navigation

Every action (`navigate`, `open_url`, `api_call`, `snackbar`) is modeled as
`ActionConfig` and executed by the single `ActionHandler.execute(...)`
method — widgets never contain navigation/API logic themselves. Navigation
is fully backend-driven: `AppRouter.onGenerateRoute` builds a `DynamicScreen`
for **any** route name it's given, so a new screen can be added on the
backend with zero client code changes.

### Form validation on submit

Every screen is wrapped in a Flutter `Form` (`SduiRenderer`), and each
`textfield` widget renders as a `TextFormField` instead of a plain
`TextField`. This gives two layers of validation from one set of rules
defined per-field in JSON:

- **Live, per-field validation** — once a field is touched,
  `AutovalidateMode.onUserInteraction` re-runs its validator on every
  keystroke, checking the format declared by `"validator"` (`email`,
  `number`).
- **Whole-form validation on submit** — an `api_call` button (e.g. "Save
  Profile") acts as the form's submit action. Before it calls the API,
  `ActionHandler` runs `Form.of(context).validate()`, which validates
  *every* field on the screen in one pass — including required fields the
  user never touched at all. If anything fails, the errors appear inline
  and a "Please fix the highlighted fields." snackbar shows; nothing is
  submitted and no success message is shown until the form is fully valid.

A field can be **required independently of its format check** via
`"required": true`, so e.g. Email must be both filled in *and* a valid
email address, not just one or the other:

```json
{ "type": "textfield", "id": "email", "label": "Email",
  "validator": "email", "required": true }
```

`WidgetConfig.required` also stays `true` for the original
`"validator": "required"` shorthand, so both styles work. See
`test/sdui_textfield_validation_test.dart` for coverage of the required +
format-check combinations.

### Timestamp validation

Screen configs can include a `generatedAt` field (ISO 8601, e.g.
`"2026-07-27T09:00:00Z"`). `DateValidator` (`core/date_validator.dart`)
strictly validates the format and rejects ambiguous or malformed strings
(e.g. `"27/07/2026"`, an out-of-range month/day) rather than trusting
`DateTime.tryParse` alone, since Dart silently normalizes some invalid
dates instead of failing. An invalid or missing timestamp never blocks the
screen from rendering — `ScreenConfig.hasInvalidTimestamp` just flags it so
the UI can show a small "invalid timestamp" hint (see the banner under the
app bar in `DynamicScreen`) instead of a hard failure. The `profile` mock
screen intentionally ships a malformed `generatedAt` to demonstrate this
live; `home` and `details` ship valid ones.

### Error handling

- **Network/parsing errors** are normalized into `ApiException` at the
  network layer, then converted to a `Result.failure` by the repository —
  callers never see raw exceptions.
- **Unknown widget types / missing `type`** render an inline
  `SduiErrorWidget` instead of throwing, so one bad node never crashes the
  whole screen (see `test/widget_factory_test.dart`).
- **Missing required properties** (e.g. a `text` widget with no `text`)
  degrade to an empty/harmless render rather than a null-check crash.
- **API failures** surface a retry UI (`DynamicScreen`'s `_ErrorState`) with
  pull-to-refresh also available on success states.

---

## 3. Design Decisions

**State management — Riverpod.**
Chosen over Bloc/Provider because:
- `FutureProvider.family` gives per-route async state (loading/error/data)
  for free, with no boilerplate events/states classes per screen — a good
  fit since routes are dynamic and not known at compile time.
- `.autoDispose` cleans up screen state automatically when a route is
  popped, which matters for a backend that could describe arbitrarily many
  screens.
- Providers are plain, testable classes with compile-time-safe DI (see
  `state/screen_providers.dart` as the single composition root), which pairs
  well with the repository pattern already required by the assignment.

**Mock backend instead of a live server.**
`MockApiClient` implements the exact same `ApiClient` interface as
`DioApiClient` and returns bundled JSON (`assets/mock/*.json`) after a
simulated delay. This keeps the assignment runnable with `flutter run` and
no separate server process, while still exercising the full
fetch → parse → cache → render → error-handle pipeline exactly as a real
network call would. Pointing the app at a real backend is a one-line change
in `screen_providers.dart` (swap `MockApiClient()` for
`DioApiClient(baseUrl: ...)`).

**`Result<T>` instead of throwing across layers.**
Forces every caller (state layer, UI) to explicitly handle both success and
failure via `.when(success: ..., failure: ...)`, rather than relying on
try/catch scattered through the UI.

**Generic `WidgetConfig` instead of one Dart class per widget type.**
Trades a small amount of type safety for the scalability the assignment
explicitly asks for ("architecture should allow adding new widget types
with minimal changes").

---

## 4. Assumptions

- No real backend was provided, so `MockApiClient` simulates
  `GET /screen/{name}` and `POST /action/{name}` using bundled JSON assets
  and a network-like delay. This was the intended interpretation of "mock
  REST API" for an offline-runnable take-home assignment.
- Three example screens are included — `home`, `details`, `profile` — to
  demonstrate navigation, a dynamic form with validation, and an
  `api_call` action end-to-end. `profile`'s JSON also intentionally includes
  one unknown widget type to demonstrate the error-handling requirement live.
- Backend color values are hex strings (`#RRGGBB` or `#AARRGGBB`); invalid
  values fall back to the current theme rather than crashing.
- "Dynamic theming" is interpreted as: the app ships proper Material
  light/dark themes (toggleable via the app bar icon), and the backend can
  additionally override specific widget colors (card/background) per screen
  — rather than the backend replacing the entire theme system.

## 5. Bonus items implemented

- ✅ Widget/screen caching (`ScreenRepositoryImpl`'s in-memory cache)
- ✅ Pull-to-refresh (`RefreshIndicator` in `DynamicScreen`)
- ✅ Image caching (`cached_network_image`)
- ✅ Unit tests (repository + widget factory, see `test/`)

Not implemented (out of scope for the 4–6 hour budget): offline persistence,
infinite scrolling, remote theme push updates, analytics, golden tests.



## 6. Output

[View Output Video](assets/mock/video/output.mp4)

Click the image to download/play the demo video.