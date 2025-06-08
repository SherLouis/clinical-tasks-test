import 'package:flutter/material.dart';
import 'test_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accueil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TestSelectionScreen()),
              ),
              child: const Text('Nouveau test'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Future: gestion de session
              },
              child: const Text('Nouvelle session'),
            ),
          ],
        ),
      ),
    );
  }
}
