import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_test_app/services/test_storage_service.dart';
import 'package:task_test_app/services/web_test_storage_service.dart';

import 'app.dart';

late final TestStorageService testStorageService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  testStorageService = WebTestStorageService();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);
  
  runApp(const TaskTestApp());
}
