import 'package:flutter/material.dart';
import 'package:task_test_app/l10n/app_localizations.dart';
import 'package:task_test_app/services/session_manager.dart';
import 'package:task_test_app/utils/app_sizes.dart';
import 'package:task_test_app/data/data_loader.dart';
import 'package:task_test_app/models/test_model.dart';
import 'test_execution_screen.dart';

class TestSelectionScreen extends StatefulWidget {
  final bool isSession;
  final bool isPreTest;

  const TestSelectionScreen({
    super.key,
    this.isSession = false,
    this.isPreTest = false,
  });

  @override
  State<TestSelectionScreen> createState() => _TestSelectionScreenState();
}

class _TestSelectionScreenState extends State<TestSelectionScreen> {
  List<TestGroup> groups = [];
  TestGroup? selectedGroup;
  bool _showHistory = true;

  @override
  void initState() {
    super.initState();
    loadTestData().then((data) => setState(() => groups = data));
  }

  @override
  Widget build(BuildContext context) {
    final completed = List.of(
      SessionManager().sessionData?.completedTests ?? [],
    );
    completed.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.chooseTest)),
      body: Row(
        children: [
          Expanded(flex: 2, child: Row(children: _buildTestTree(context))),
          // Panneau historique
          if (widget.isSession)
            Container(
              width: 10,
              child: GestureDetector(
                onTap: () => setState(() => _showHistory = !_showHistory),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Center(
                    child: Icon(
                      _showHistory
                          ? Icons.arrow_forward_ios
                          : Icons.arrow_back_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          // TOdO: when selecting from history list, start the test
          if (widget.isSession && _showHistory)
            Container(
              width: 300,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.testHistory,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: completed.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppLocalizations.of(context)!.noCompletedTest,
                            ),
                          )
                        : ListView.builder(
                            itemCount: completed.length,
                            itemBuilder: (_, index) {
                              final test = completed[index];
                              return ListTile(
                                dense: true,
                                title: Text(test.testName),
                                trailing: Text(
                                  _formatDateTime(test.completedAt),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                onTap: () async {
                                  await _startTestByName(
                                    test.groupName,
                                    test.testName,
                                    false,
                                  );
                                  setState(() {});
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _startTest(
    TestItem test,
    String testGroup,
    bool isPreTest,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TestExecutionScreen(
          test: test,
          groupName: testGroup,
          isPreTest: isPreTest,
        ),
      ),
    );
  }

  Future<void> _startTestByName(
    String groupName,
    String testName,
    bool isPreTest,
  ) async {
    TestItem testItem = groups
        .firstWhere((g) => g.name == groupName)
        .testItems
        .firstWhere((t) => t.name == testName);
    await _startTest(testItem, groupName, isPreTest);
  }

  List<Widget> _buildTestTree(BuildContext context) {
    return [
      Expanded(
        child: ListView(
          children: groups
              .map(
                (g) => ListTile(
                  title: Text(
                    g.name,
                    style: TextStyle(fontSize: AppSizes.fontSize(context)),
                  ),
                  selected: g == selectedGroup,
                  onTap: () => setState(() {
                    selectedGroup = g;
                  }),
                ),
              )
              .toList(),
        ),
      ),
      Expanded(
        child: ListView(
          children:
              selectedGroup?.testItems
                  .map(
                    (t) => ListTile(
                      title: Text(
                        t.name,
                        style: TextStyle(fontSize: AppSizes.fontSize(context)),
                      ),
                      onTap: () async {
                        await _startTest(
                          t,
                          selectedGroup!.name,
                          widget.isPreTest,
                        );
                        setState(() {});
                      },
                    ),
                  )
                  .toList() ??
              [],
        ),
      ),
    ];
  }

  String _formatDateTime(DateTime dt) {
    final date = dt.toLocal();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} $hour:$minute';
  }
}
