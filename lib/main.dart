import 'package:flutter/material.dart';
import 'package:study_box/screens/login_page.dart';

void main() {
  runApp(const StudyBoxApp());
}

class StudyBoxApp extends StatelessWidget {
  const StudyBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TechCatalog',
      home: const LoginScreen(),
    );
  }
}
