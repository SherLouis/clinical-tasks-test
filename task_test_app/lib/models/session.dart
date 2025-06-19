class SessionData {
  final String sessionId;
  final Set<String> skippedImages = {};
  final List<CompletedTest> completedTests = [];

  SessionData({required this.sessionId});
}

class CompletedTest {
  final String groupName;
  final String subGroupName;
  final String testName;
  final DateTime completedAt;

  CompletedTest({
    required this.groupName,
    required this.subGroupName,
    required this.testName,
    required this.completedAt,
  });
}
