import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/test_model.dart';
import 'package:task_test_app/services/web_test_storage_service.dart';

Future<List<TestGroup>> loadTestData() async {
  final service = WebTestStorageService();
  return await service.loadTestGroups();
}
