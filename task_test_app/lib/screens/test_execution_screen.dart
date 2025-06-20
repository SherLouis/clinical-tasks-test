import 'package:flutter/material.dart';
import '../models/test_model.dart';
import '../widgets/image_test_view.dart';

class TestExecutionScreen extends StatelessWidget {
  final TestItem test;
  final String groupName;
  final String subGroupName;
  final bool isPreTest;

  const TestExecutionScreen({
    super.key,
    required this.test,
    required this.groupName,
    required this.subGroupName,
    required this.isPreTest
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ImageTestView(
        images: test.imagePaths,
        groupName: groupName,
        subGroupName: subGroupName,
        testName: test.name,
        isPreTest: isPreTest,
      ),
    );
  }
}
