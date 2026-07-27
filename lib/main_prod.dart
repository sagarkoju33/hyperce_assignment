/// Production flavor entrypoint.
/// flutter run -t lib/main_prod.dart --dart-define=FLAVOR=prod --dart-define=API_BASE_URL=https://api.example.com
library;

import 'bootstrap.dart';

Future<void> main() => bootstrap();
