import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class TaskTestApp extends StatelessWidget {
  const TaskTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testeur de tâches',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
