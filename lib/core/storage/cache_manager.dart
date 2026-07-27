class CacheManager {
  CacheManager({Duration ttl = const Duration(minutes: 15)}) : _ttl = ttl;

  final Duration _ttl;
  final Map<String, _CacheEntry> _cache = {};

  void set(String key, Object value) {
    _cache[key] = _CacheEntry(value, DateTime.now().add(_ttl));
  }

  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;
    if (DateTime.now().isAfter(entry.expiresAt)) {
      _cache.remove(key);
      return null;
    }
    return entry.value as T?;
  }

  void invalidate(String key) => _cache.remove(key);

  void clear() => _cache.clear();
}

class _CacheEntry {
  _CacheEntry(this.value, this.expiresAt);
  final Object value;
  final DateTime expiresAt;
}
