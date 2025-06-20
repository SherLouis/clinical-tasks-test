import '../models/session.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() => _instance;

  SessionManager._internal();

  SessionData? _currentSession;

  final Set<SessionData> _allSessions = {};

  bool get hasActiveSession => _currentSession != null;
  SessionData? get sessionData => _currentSession;

  void startSession(String sessionId) {
    final session = SessionData(sessionId: sessionId);
    _currentSession = session;
    _allSessions.add(session);
  }

  void endSession() {
    _currentSession = null;
  }

  bool hasSession(String id) => allSessionIds().contains(id);

  List<String> allSessionIds() => _allSessions.map((s) => s.sessionId).toList();

  List<SessionData> allSessions() =>
      _allSessions.toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  String? get currentSessionId => _currentSession?.sessionId;

  void resumeSession(String id) {
    _currentSession = _allSessions.firstWhere(
      (s) => s.sessionId == id,
      orElse: () => throw Exception('Session "$id" not found'),
    );
  }

  void deleteSession(String sessionId) {
    _allSessions.removeWhere((s) => s.sessionId == sessionId);
    if (_currentSession?.sessionId == sessionId) {
      _currentSession = null;
    }
  }

  void skipImage(String group, String subGroup, String test, String imagePath) {
    if (_currentSession == null) return;
    final key = _getTestKey(group, subGroup, test);
    _currentSession!.skippedImagesByTest
        .putIfAbsent(key, () => {})
        .add(imagePath);
  }

  bool isImageSkipped(
    String group,
    String subGroup,
    String test,
    String imagePath,
  ) {
    if (_currentSession == null) return false;
    final key = _getTestKey(group, subGroup, test);
    return _currentSession!.skippedImagesByTest[key]?.contains(imagePath) ??
        false;
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

  String _getTestKey(String group, String subGroup, String test) =>
      '$group|$subGroup|$test';
}
