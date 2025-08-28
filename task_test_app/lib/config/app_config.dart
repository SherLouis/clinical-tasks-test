class AppConfig {
  // Cache settings
  static const Duration cacheExpirationDays = Duration(days: 30);

  // Debug settings
  static const bool enableCacheLogging = false;

  // Get cache expiration date
  static DateTime get cacheExpirationDate {
    return DateTime.now().add(cacheExpirationDays);
  }

  // Check if cache is expired
  static bool isCacheExpired(DateTime lastUpdated) {
    return DateTime.now().isAfter(cacheExpirationDate);
  }
}
