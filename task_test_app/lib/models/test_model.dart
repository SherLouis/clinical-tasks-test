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

// Version-aware test data model
class VersionedTestData {
  final String version;
  final List<TestGroup> testGroups;
  final DateTime lastUpdated;

  VersionedTestData({
    required this.version,
    required this.testGroups,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'testGroups': testGroups.map((group) => {
        'name': group.name,
        'testItems': group.testItems.map((item) => {
          'name': item.name,
          'imagePaths': item.imagePaths,
          'complementaryImagePaths': item.complementaryImagePaths,
          'instructionsImagePaths': item.instructionsImagePaths,
        }).toList(),
      }).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory VersionedTestData.fromJson(Map<String, dynamic> json) {
    return VersionedTestData(
      version: json['version'],
      testGroups: (json['testGroups'] as List).map((group) {
        return TestGroup(
          name: group['name'],
          testItems: (group['testItems'] as List).map((item) {
            return TestItem(
              name: item['name'],
              imagePaths: List<String>.from(item['imagePaths']),
              complementaryImagePaths: List<String>.from(item['complementaryImagePaths']),
              instructionsImagePaths: List<String>.from(item['instructionsImagePaths']),
            );
          }).toList(),
        );
      }).toList(),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
