import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/test_model.dart';
import '../services/image_cache_service.dart';
import '../config/app_config.dart';

class TestDataInfo {
  final String version;
  final DateTime lastUpdated;
  final List<TestGroup> testGroups;

  TestDataInfo({
    required this.version,
    required this.lastUpdated,
    required this.testGroups,
  });
}

Future<TestDataInfo> loadTestDataInfo() async {
  final String jsonString = await rootBundle.loadString(
    'assets/data/tests.json',
  );
  final jsonData = json.decode(jsonString) as Map<String, dynamic>;

  final version = jsonData['version'] as String;
  final lastUpdated = DateTime.parse(jsonData['last_updated'] as String);
  
  final testGroups = (jsonData['tests'] as List).map((group) {
    return TestGroup(
      name: group['category_name'],
      testItems: (group['tests'] as List).map((test) {
        return TestItem(
          name: test['name'],
          imagePaths: List<String>.from(test['test_images']),
          complementaryImagePaths: test["complementary_material_images"] != null
              ? List<String>.from(test['complementary_material_images'])
              : List.empty(),
          instructionsImagePaths: test["instructions"] != null
              ? List<String>.from(test['instructions'])
              : List.empty(),
        );
      }).toList(),
    );
  }).toList();

  return TestDataInfo(
    version: version,
    lastUpdated: lastUpdated,
    testGroups: testGroups,
  );
}

Future<List<TestGroup>> loadTestData() async {
  final prefs = await SharedPreferences.getInstance();
  
  // Load fresh data info from assets to check version
  final freshDataInfo = await loadTestDataInfo();
  
  // Check if we have cached data and if it's up to date
  final cachedVersion = prefs.getString('data_version');
  final cachedLastUpdated = prefs.getString('data_last_updated');
  final cachedDataJson = prefs.getString('cached_test_data');

  if (AppConfig.enableCacheLogging) {
    debugPrint('Got preferences: cachedVersion=$cachedVersion cachedLastUpdated=$cachedLastUpdated');
  }
  
  final needsUpdate = cachedVersion != freshDataInfo.version ||
                     (cachedLastUpdated != null && 
                      AppConfig.isCacheExpired(DateTime.parse(cachedLastUpdated)));
  
  if (!needsUpdate && cachedDataJson != null) {
    if (AppConfig.enableCacheLogging) {
      debugPrint('Loading cached test data (version: $cachedVersion)');
    }
    
    try {
      final json = jsonDecode(cachedDataJson);
      final cachedData = VersionedTestData.fromJson(json);
      return cachedData.testGroups;
    } catch (e) {
      debugPrint('Error loading cached data: $e');
    }
  }
  
  // Load fresh data from assets
  if (AppConfig.enableCacheLogging) {
    debugPrint('Loading fresh test data from assets (version: ${freshDataInfo.version})');
  }

  // Create versioned data and cache it
  final versionedData = VersionedTestData(
    version: freshDataInfo.version,
    testGroups: freshDataInfo.testGroups,
    lastUpdated: freshDataInfo.lastUpdated,
  );
  
  // Save to SharedPreferences
  await prefs.setString('data_version', freshDataInfo.version);
  await prefs.setString('data_last_updated', freshDataInfo.lastUpdated.toIso8601String());
  await prefs.setString('cached_test_data', jsonEncode(versionedData.toJson()));
  
  // Pre-cache all images immediately
  await _preCacheAllImages(freshDataInfo.testGroups);
  
  return freshDataInfo.testGroups;
}

// Pre-cache all images for immediate access
Future<void> _preCacheAllImages(List<TestGroup> testGroups) async {
  final imageCacheService = ImageCacheService.instance;
  
  // Collect all image URLs
  final allImageUrls = <String>[];
  
  for (final group in testGroups) {
    for (final item in group.testItems) {
      allImageUrls.addAll(item.imagePaths);
      allImageUrls.addAll(item.complementaryImagePaths);
      allImageUrls.addAll(item.instructionsImagePaths);
    }
  }
  
  // Remove duplicates
  final uniqueImageUrls = allImageUrls.toSet().toList();
  
  if (AppConfig.enableCacheLogging) {
    debugPrint('Pre-caching ${uniqueImageUrls.length} images...');
  }
  
  // Pre-cache all images
  await imageCacheService.preCacheImages(uniqueImageUrls);
  
  if (AppConfig.enableCacheLogging) {
    debugPrint('Pre-cache completed for ${uniqueImageUrls.length} images');
  }
}

