import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/test_model.dart';

Future<List<TestGroup>> loadTestData() async {
  final String jsonString = await rootBundle.loadString('assets/data/tests.json');
  final jsonData = json.decode(jsonString);

  return (jsonData as List).map((group) {
    return TestGroup(
      name: group['name'],
      subGroups: (group['subGroups'] as List).map((sub) {
        return TestSubGroup(
          name: sub['name'],
          tests: (sub['tests'] as List).map((t) {
            return TestItem(
              name: t['name'],
              imagePaths: List<String>.from(t['images']),
            );
          }).toList(),
        );
      }).toList(),
    );
  }).toList();
}
