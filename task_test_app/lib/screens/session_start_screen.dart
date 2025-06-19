import 'package:flutter/material.dart';
import 'package:task_test_app/l10n/app_localizations.dart';
import '../services/session_manager.dart';
import 'test_selection_screen.dart';
import '../utils/app_sizes.dart';

class SessionStartScreen extends StatefulWidget {
  const SessionStartScreen({super.key});

  @override
  State<SessionStartScreen> createState() => _SessionStartScreenState();
}

class _SessionStartScreenState extends State<SessionStartScreen> {
  final TextEditingController _controller = TextEditingController();
  String _sessionId = '';

  void _onContinue(bool isPreTest) {
    final sessionId = _sessionId.trim();
    if (sessionId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.session_enterIdSnack,
            style: TextStyle(
              fontSize: AppSizes.fontSize(context),
              color: Colors.white,
            ),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    SessionManager().startSession(sessionId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TestSelectionScreen(isSession: true, isPreTest: isPreTest),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final double fontSize = AppSizes.fontSize(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.startNewSession)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t.session_enterIdLabel,
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    _sessionId = value;
                  });
                },
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'ex: session-001',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _onContinue(true),
                child: Text(
                  t.session_startPreTest,
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _onContinue(false),
                child: Text(
                  t.session_startTest,
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
