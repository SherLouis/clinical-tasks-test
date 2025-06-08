import 'package:flutter/material.dart';
import '../models/test_model.dart';
import '../widgets/image_test_view.dart';

class TestExecutionScreen extends StatelessWidget {
  final TestItem test;

  const TestExecutionScreen({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ImageTestView(images: test.imagePaths),
    );
  }
}
