class SessionData {
  final String sessionId;
  final DateTime createdAt = DateTime.now();
  final Map<String, Set<String>> skippedImagesByTest;

  final List<CompletedTest> completedTests = [];

  SessionData({required this.sessionId}) : skippedImagesByTest = {};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionData && sessionId == other.sessionId;

  @override
  int get hashCode => sessionId.hashCode;
}

class CompletedTest {
  final String groupName;
  final String testName;
  final DateTime completedAt;

  CompletedTest({
    required this.groupName,
    required this.testName,
    required this.completedAt,
  });
}
