import 'package:flutter/material.dart';

abstract class TestStorageService {
  Future<void> initialize();
  Future<int> getLocalVersion();
  Future<void> saveLocalVersion(int version);
  Future<Map<String, dynamic>> loadTestConfig();
  Future<void> saveTestConfig(Map<String, dynamic> config);
  Future<void> downloadImages(List<String> imagePaths);
  Future<bool> isImageCached(String imagePath);
  ImageProvider loadImage(String imagePath);
}
