class AppConfig {
  // Current version of the test data
  // Increment this when you make changes to tests.json or add new test images

  // TODO: check if all needed and maybe move config to a separate file
  // TODO: do not use this. Use the version from the data file.
  static const String testDataVersion = '1.0.0';
  
  // Cache settings
  static const Duration cacheExpirationDays = Duration(days: 30);
  static const int maxCacheSizeMB = 100; // Maximum cache size in MB
  
  // Network settings
  static const Duration networkTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  
  // Debug settings
  static const bool enableDebugLogging = true;
  static const bool enableCacheLogging = true;
  
  // Feature flags
  static const bool enableBackgroundCaching = true;
  static const bool enableAutoRefresh = true;
  
  // Get cache expiration date
  static DateTime get cacheExpirationDate {
    return DateTime.now().add(cacheExpirationDays);
  }
  
  // Check if cache is expired
  static bool isCacheExpired(DateTime lastUpdated) {
    return DateTime.now().isAfter(lastUpdated.add(cacheExpirationDays));
  }
  
  // Format cache size for display
  static String formatCacheSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}
