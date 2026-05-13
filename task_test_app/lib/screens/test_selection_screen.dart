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

  const TestSelectionScreen({super.key, this.isSession = false});

  @override
  State<TestSelectionScreen> createState() => _TestSelectionScreenState();
}

class _TestSelectionScreenState extends State<TestSelectionScreen> {
  List<TestGroup> groups = [];
  TestGroup? selectedGroup;
  bool _showHistory = true;
  bool _isLoading = true;
  TestItem? selectedTest;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await loadTestData();
    setState(() {
      groups = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final completed = List.of(
      SessionManager().sessionData?.completedTests ?? [],
    );
    completed.sort((a, b) => b.completedAt.compareTo(a.completedAt));

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.chooseTest)),
      body: Stack(
        children: [
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(40),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.loadingData,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppSizes.fontSize(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Row(
            children: [
              // Catégories
              Expanded(
                child: ListView(
                  children: groups.map((g) {
                    final isSelected = g == selectedGroup;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                          foregroundColor: isSelected
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedGroup = isSelected ? null : g;
                            selectedTest = null;
                          });
                        },
                        child: Text(
                          g.name,
                          style: TextStyle(
                            fontSize: AppSizes.fontSize(context),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Tests
              Expanded(
                child: Container(
                  color: selectedGroup != null ? null : null,
                  child: ListView(
                    children:
                        selectedGroup?.testItems.map((t) {
                          final isTestSelected = selectedTest == t;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isTestSelected
                                        ? Theme.of(context).colorScheme.tertiary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer,
                                    foregroundColor: isTestSelected
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onTertiary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onPrimaryContainer,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedTest = isTestSelected ? null : t;
                                    });
                                  },
                                  child: Text(
                                    t.name,
                                    style: TextStyle(
                                      fontSize: AppSizes.fontSize(context),
                                    ),
                                  ),
                                ),
                              ),
                              if (isTestSelected) _buildTestOptions(t),
                            ],
                          );
                        }).toList() ??
                        [],
                  ),
                ),
              ),

              // Test History panel
              if (widget.isSession)
                SizedBox(
                  width: 20,
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
        ],
      ),
    );
  }

  Widget _buildTestOptions(TestItem test) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Démarrer
          _buildOptionButton(
            icon: Icons.play_arrow,
            label: AppLocalizations.of(context)!.startTest,
            color: Colors.green,
            onTap: () async {
              await _startTest(test, selectedGroup!.name, false);
            },
          ),
          // Pré-test (seulement si session)
          if (widget.isSession)
            _buildOptionButton(
              icon: Icons.school,
              label: AppLocalizations.of(context)!.startPreTest,
              onTap: () async {
                await _startTest(test, selectedGroup!.name, true);
              },
            ),
          // Instructions
          _buildOptionButton(
            icon: Icons.help_outline,
            label: AppLocalizations.of(context)!.instructions,
            onTap: _showInstructions,
            disabled: test.instructionsImagePaths.isEmpty,
          ),

          // Matériel complémentaire
          _buildOptionButton(
            icon: Icons.library_books,
            label: AppLocalizations.of(context)!.complementary,
            onTap: _showComplementary,
            disabled: test.complementaryImagePaths.isEmpty,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
    bool disabled = false,
  }) {
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Opacity(
        opacity: disabled ? 0.4 : 1.0,
        child: SizedBox(
          width: 72,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 60,
                color: color ?? Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
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

  void _showInstructions() {
    if (selectedTest?.instructionsImagePaths.isNotEmpty == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MaterialViewer(
            imagePaths: selectedTest!.instructionsImagePaths,
            title: AppLocalizations.of(context)!.instructions,
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
            title: AppLocalizations.of(context)!.complementary,
          ),
        ),
      );
    }
  }

  String _formatDateTime(DateTime dt) {
    final date = dt.toLocal();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} $hour:$minute';
  }
}
