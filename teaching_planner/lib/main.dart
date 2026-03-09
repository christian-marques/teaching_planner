import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'services/student_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StudentStorageService.init();
  runApp(const TeachingPlannerApp());
}

class TeachingPlannerApp extends StatelessWidget {
  const TeachingPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Teaching Planner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF5DEB3)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}