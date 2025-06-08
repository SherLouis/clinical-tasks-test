class TestGroup {
  final String name;
  final List<TestSubGroup> subGroups;

  TestGroup({required this.name, required this.subGroups});
}

class TestSubGroup {
  final String name;
  final List<TestItem> tests;

  TestSubGroup({required this.name, required this.tests});
}

class TestItem {
  final String name;
  final List<String> imagePaths;

  TestItem({required this.name, required this.imagePaths});
}
