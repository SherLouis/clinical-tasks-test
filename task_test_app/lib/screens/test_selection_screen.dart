import 'package:flutter/material.dart';
import '../data/data_loader.dart';
import '../models/test_model.dart';
import 'test_execution_screen.dart';

class TestSelectionScreen extends StatefulWidget {
  const TestSelectionScreen({super.key});

  @override
  State<TestSelectionScreen> createState() => _TestSelectionScreenState();
}

class _TestSelectionScreenState extends State<TestSelectionScreen> {
  List<TestGroup> groups = [];
  TestGroup? selectedGroup;
  TestSubGroup? selectedSubGroup;

  @override
  void initState() {
    super.initState();
    loadTestData().then((data) => setState(() => groups = data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choisir un test')),
      body: Row(
        children: [
          Expanded(
            child: ListView(
              children: groups.map((g) => ListTile(
                title: Text(g.name),
                selected: g == selectedGroup,
                onTap: () => setState(() {
                  selectedGroup = g;
                  selectedSubGroup = null;
                }),
              )).toList(),
            ),
          ),
          Expanded(
            child: ListView(
              children: selectedGroup?.subGroups.map((sg) => ListTile(
                title: Text(sg.name),
                selected: sg == selectedSubGroup,
                onTap: () => setState(() => selectedSubGroup = sg),
              )).toList() ?? [],
            ),
          ),
          Expanded(
            child: ListView(
              children: selectedSubGroup?.tests.map((t) => ListTile(
                title: Text(t.name),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => TestExecutionScreen(test: t),
                  ));
                },
              )).toList() ?? [],
            ),
          ),
        ],
      ),
    );
  }
}
