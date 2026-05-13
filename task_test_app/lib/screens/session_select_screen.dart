import 'package:flutter/material.dart';
import 'package:task_test_app/l10n/app_localizations.dart';
import 'package:task_test_app/models/session.dart';
import 'package:task_test_app/screens/test_selection_screen.dart';
import 'package:task_test_app/services/session_manager.dart';
import 'package:task_test_app/widgets/language_switcher.dart';

class SessionSelectScreen extends StatefulWidget {
  const SessionSelectScreen({super.key});

  @override
  State<SessionSelectScreen> createState() => _SessionSelectScreenState();
}

class _SessionSelectScreenState extends State<SessionSelectScreen> {
  late List<SessionData> _sessions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reloadSessions();
  }

  void _reloadSessions() {
    setState(() {
      _sessions = SessionManager().allSessions();
    });
  }

  Future<void> _showCreateDialog() async {
    final t = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    final created = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.createSession),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'ex: session-001'),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final id = controller.text.trim();
              if (id.isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(t.session_idRequired)));
                return;
              }
              if (SessionManager().hasSession(id)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t.session_idAlreadyExists)),
                );
                return;
              }
              SessionManager().startSession(id);
              Navigator.pop(context, true);
            },
            child: Text(t.create),
          ),
        ],
      ),
    );

    if (created == true) {
      _reloadSessions();
      // Navigate directly to test selection
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const TestSelectionScreen(isSession: true),
        ),
      );
    }
  }

  Future<bool> _confirmDeleteSession(SessionData session) async {
    final t = AppLocalizations.of(context)!;

    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(t.deleteSession),
            content: Text(t.confirmDeleteSession(session.sessionId)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(t.cancel),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                onPressed: () => Navigator.pop(context, true),
                label: Text(t.delete),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _selectSession(SessionData session) {
    SessionManager().resumeSession(session.sessionId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TestSelectionScreen(isSession: true),
      ),
    ).then((_) => _reloadSessions());
  }

  @override
  void initState() {
    super.initState();
    _sessions = SessionManager().allSessions();
    // Si aucune session, ouvrir le dialogue automatiquement après le premier frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_sessions.isEmpty) _showCreateDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.selectSession),
        actions: const [
          LanguageSwitcher(),
          SizedBox(width: 8),
        ],
      ),
      body: _sessions.isEmpty
          ? Center(child: Text(t.noSessions))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _sessions.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, idx) {
                final s = _sessions[idx];
                return Dismissible(
                  key: ValueKey(s.sessionId),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (_) async => await _confirmDeleteSession(s),
                  onDismissed: (_) {
                    SessionManager().deleteSession(s.sessionId);
                    _reloadSessions();
                  },
                  child: ListTile(
                    title: Text(s.sessionId),
                    subtitle: Text(
                      '${AppLocalizations.of(context)!.created}: ${s.createdAt.toLocal().toString().split(' ').first}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        final shouldDelete = await _confirmDeleteSession(s);
                        if (shouldDelete) {
                          SessionManager().deleteSession(s.sessionId);
                          _reloadSessions();
                        }
                      },
                    ),
                    onTap: () => _selectSession(s),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
