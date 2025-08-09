import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/test_model.dart';

Future<List<TestGroup>> loadTestData() async {
  final String jsonString = await rootBundle.loadString(
    'assets/data/tests.json',
  );
  final jsonData = json.decode(jsonString);

  return (jsonData as List).map((group) {
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
}
