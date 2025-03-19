import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/students.dart';
import 'pages/finance.dart';
import 'pages/calendar.dart';
import 'pages/schedule.dart'; // Adicionada a nova página

void main() {
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
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const StudentsPage(),
    const FinancePage(),
    const CalendarPage(),
    const SchedulePage(), // Grade Horária adicionada
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Fecha o menu após selecionar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teaching Planner')),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: const Color(0xFFF5DEB3)), // Bege
              child: const Center(
                child: Text(
                  'Teaching Planner',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Início'),
                    onTap: () => _onItemTapped(0),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Alunos'),
                    onTap: () => _onItemTapped(1),
                  ),
                  ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: const Text('Finanças'),
                    onTap: () => _onItemTapped(2),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Calendário'),
                    onTap: () => _onItemTapped(3),
                  ),
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: const Text('Grade Horária'), // Adicionada a Grade Horária
                    onTap: () => _onItemTapped(4),
                  ),
                ],
              ),
            ),
            // Botão de Fechar no Rodapé
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text('Fechar Menu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
