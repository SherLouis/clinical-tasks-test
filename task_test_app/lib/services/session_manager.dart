import '../models/session.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() => _instance;

  SessionManager._internal();

  SessionData? _currentSession;

  bool get hasActiveSession => _currentSession != null;
  SessionData? get sessionData => _currentSession;

  void startSession(String sessionId) {
    _currentSession = SessionData(sessionId: sessionId);
  }

  void endSession() {
    _currentSession = null;
  }

  void skipImage(String imagePath) {
    _currentSession?.skippedImages.add(imagePath);
  }

  bool isImageSkipped(String imagePath) {
    return _currentSession?.skippedImages.contains(imagePath) ?? false;
  }

  void addCompletedTest(String group, String subGroup, String test) {
    if (_currentSession == null) return;
    _currentSession!.completedTests.add(
      CompletedTest(
        groupName: group,
        subGroupName: subGroup,
        testName: test,
        completedAt: DateTime.now(),
      ),
    );
  }
}
