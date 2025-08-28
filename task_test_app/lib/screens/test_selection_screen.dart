import 'package:flutter/material.dart';
import 'package:task_test_app/l10n/app_localizations.dart';
import 'package:task_test_app/services/session_manager.dart';
import 'package:task_test_app/utils/app_sizes.dart';
import 'package:task_test_app/data/data_loader.dart';
import 'package:task_test_app/models/test_model.dart';
import 'package:task_test_app/widgets/material_viewer.dart';
import 'test_execution_screen.dart';

class TestSelectionScreen extends StatefulWidget {
  final bool isSession;

  const TestSelectionScreen({
    super.key,
    this.isSession = false,
  });

  @override
  State<TestSelectionScreen> createState() => _TestSelectionScreenState();
}

class _TestSelectionScreenState extends State<TestSelectionScreen> {
  List<TestGroup> groups = [];
  TestGroup? selectedGroup;
  bool _showHistory = true;
  TestItem? selectedTest;
  bool _showOptionsDrawer = false;

  @override
  void initState() {
    super.initState();
    // TODO: add overlay loader while loading data
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
      body: GestureDetector(
        onTap: _showOptionsDrawer ? _closeOptionsDrawer : null,
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(flex: 2, child: Row(children: _buildTestTree(context))),
                // Panneau historique
                if (widget.isSession)
                                  SizedBox(
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
                  SizedBox(
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
            // Semi-transparent overlay
            if (_showOptionsDrawer)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
              ),
            // Options Drawer
            if (_showOptionsDrawer)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {}, // Prevent closing when tapping inside drawer
                  child: _buildOptionsDrawer(context),
                ),
              ),
          ],
        ),
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

  void _showTestOptions(TestItem test) {
    setState(() {
      selectedTest = test;
      _showOptionsDrawer = true;
    });
  }

  void _closeOptionsDrawer() {
    setState(() {
      _showOptionsDrawer = false;
      selectedTest = null;
    });
  }

  void _closeOptionsDrawerOnly() {
    setState(() {
      _showOptionsDrawer = false;
    });
  }

  void _showInstructions() {
    if (selectedTest?.instructionsImagePaths.isNotEmpty == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MaterialViewer(
            imagePaths: selectedTest!.instructionsImagePaths,
            title: 'Instructions',
          ),
        ),
      );
    }
  }

  void _showComplementary() {
    if (selectedTest?.complementaryImagePaths.isNotEmpty == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MaterialViewer(
            imagePaths: selectedTest!.complementaryImagePaths,
            title: 'Complementary Material',
          ),
        ),
      );
    }
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
                      onTap: () {
                        _showTestOptions(t);
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

  Widget _buildOptionsDrawer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${selectedTest?.name} - ${AppLocalizations.of(context)!.testOptions}',
              style: TextStyle(
                fontSize: AppSizes.fontSize(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Start test button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: Text(AppLocalizations.of(context)!.startTest),
                    onPressed: () async {
                      if (selectedTest != null && selectedGroup != null) {
                        final test = selectedTest!;
                        final groupName = selectedGroup!.name;
                        final isPreTest = false; // Default to regular test, pre-test is selected in drawer
                        _closeOptionsDrawerOnly();
                        await _startTest(
                          test,
                          groupName,
                          isPreTest,
                        );
                        setState(() {
                          selectedTest = null; // Clear after navigation
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // Start pre-test button (only if in session mode)
                if (widget.isSession)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.school),
                      label: Text(AppLocalizations.of(context)!.startPreTest),
                      onPressed: () async {
                        if (selectedTest != null && selectedGroup != null) {
                          final test = selectedTest!;
                          final groupName = selectedGroup!.name;
                          _closeOptionsDrawerOnly();
                          await _startTest(
                            test,
                            groupName,
                            true, // isPreTest
                          );
                          setState(() {
                            selectedTest = null; // Clear after navigation
                          });
                        }
                      },
                    ),
                  ),
                if (widget.isSession) const SizedBox(height: 8),
                // Show instructions button (only if available)
                if (selectedTest?.instructionsImagePaths.isNotEmpty == true)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.help_outline),
                      label: Text(AppLocalizations.of(context)!.showInstructions),
                      onPressed: _showInstructions,
                    ),
                  ),
                if (selectedTest?.instructionsImagePaths.isNotEmpty == true)
                  const SizedBox(height: 8),
                // Show complementary material button (only if available)
                if (selectedTest?.complementaryImagePaths.isNotEmpty == true)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.library_books),
                      label: Text(AppLocalizations.of(context)!.showComplementary),
                      onPressed: _showComplementary,
                    ),
                  ),
                if (selectedTest?.complementaryImagePaths.isNotEmpty == true)
                  const SizedBox(height: 8),
                // Close button
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    icon: const Icon(Icons.close),
                    label: Text(AppLocalizations.of(context)!.cancel),
                    onPressed: _closeOptionsDrawer,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
