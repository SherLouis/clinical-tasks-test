import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:task_test_app/models/test_model.dart';
import 'test_storage_service.dart';

class WebTestStorageService extends TestStorageService {
  final String baseUrl = kReleaseMode
      ? 'https://sherlouis.github.io/clinical-tasks-test/assets/'
      : 'http://localhost:42783/assets';
  final DefaultCacheManager _cacheManager = DefaultCacheManager();

  int _localVersion = 0;
  Map<String, dynamic>? _config;

  @override
  Future<void> initialize() async {
    // On peut charger le fichier local version.json si tu veux plus tard
  }

  @override
  Future<int> getLocalVersion() async {
    return _localVersion;
  }

  @override
  Future<void> saveLocalVersion(int version) async {
    _localVersion = version;
  }

  @override
  Future<Map<String, dynamic>> loadTestConfig() async {
    final remote = await http.get(Uri.parse('$baseUrl/data/tests.json'));

    final jsonData = json.decode(remote.body) as Map<String, dynamic>;
    final remoteVersion = jsonData['version'] ?? 0;

    if (remoteVersion > _localVersion) {
      _config = jsonData;
      await saveLocalVersion(remoteVersion);

      // pré-télécharger les images
      final images = _extractImages(jsonData);
      await downloadImages(images);
    }

    return _config ?? jsonData;
  }

  Future<List<TestGroup>> loadTestGroups() async {
    final testConfig = await loadTestConfig();
    final List<dynamic> rawGroups = testConfig['groups'];
    return rawGroups
        .map(
          (e) => TestGroup(
            name: e['name'],
            subGroups: (e['subGroups'] as List<dynamic>)
                .map(
                  (sub) => TestSubGroup(
                    name: sub['name'],
                    tests: (sub['tests'] as List<dynamic>)
                        .map(
                          (t) => TestItem(
                            name: t['name'],
                            imagePaths: List<String>.from(t['images']),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  List<String> _extractImages(Map<String, dynamic> json) {
    final List<String> result = [];
    for (final group in json['groups']) {
      for (final sub in group['subGroups']) {
        for (final test in sub['tests']) {
          for (final img in test['images']) {
            result.add(img);
          }
        }
      }
    }
    return result;
  }

  @override
  Future<void> downloadImages(List<String> imagePaths) async {
    for (final imagePath in imagePaths) {
      final fullUrl = '$baseUrl/images/$imagePath';
      await _cacheManager.downloadFile(fullUrl, key: imagePath);
    }
  }

  @override
  Future<bool> isImageCached(String imagePath) async {
    final fileInfo = await _cacheManager.getFileFromCache(imagePath);
    return fileInfo != null;
  }

  @override
  ImageProvider loadImage(String imagePath) {
    throw UnimplementedError('Use loadImageAsync instead for Web');
  }

  /// Charge l'image depuis le cache (ou la télécharge si manquante)
  Future<ImageProvider> loadImageAsync(String imagePath) async {
    final file = await _cacheManager.getSingleFile(
      '$baseUrl/images/$imagePath',
      key: imagePath,
    );
    return MemoryImage(await file.readAsBytes());
  }

  @override
  Future<void> saveTestConfig(Map<String, dynamic> config) async {
    _config = config;
  }
}
