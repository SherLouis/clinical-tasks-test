import 'package:flutter/material.dart';
import 'package:task_test_app/utils/app_sizes.dart';
import 'test_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Accueil',
          style: TextStyle(fontSize: AppSizes.fontSize(context)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TestSelectionScreen()),
              ),
              child: Text(
                'Nouveau test',
                style: TextStyle(fontSize: AppSizes.fontSize(context)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Future: gestion de session
              },
              child: Text(
                'Nouvelle session',
                style: TextStyle(fontSize: AppSizes.fontSize(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
