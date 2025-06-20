import 'package:flutter/material.dart';
import 'package:task_test_app/l10n/app_localizations.dart';
import 'package:task_test_app/screens/test_selection_screen.dart';
import 'package:task_test_app/services/session_manager.dart';
import 'package:task_test_app/utils/app_sizes.dart';

class SessionModeScreen extends StatelessWidget {
  const SessionModeScreen({super.key});

  void _startTest(BuildContext context, {required bool isPreTest}) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${t.session_selectTestMode} (${SessionManager().currentSessionId!})',
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _startTest(context, isPreTest: true),
                child: Text(
                  t.session_startPreTest,
                  style: TextStyle(fontSize: AppSizes.fontSize(context)),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _startTest(context, isPreTest: false),
                child: Text(
                  t.session_startTest,
                  style: TextStyle(fontSize: AppSizes.fontSize(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
