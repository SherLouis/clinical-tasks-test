class TestGroup {
  final String name;
  final List<TestItem> testItems;

  TestGroup({required this.name, required this.testItems});
}

class TestItem {
  final String name;
  final List<String> imagePaths;
  final List<String> complementaryImagePaths;
  final List<String> instructionsImagePaths;

  TestItem({required this.name, required this.imagePaths, required this.complementaryImagePaths, required this.instructionsImagePaths});
}
