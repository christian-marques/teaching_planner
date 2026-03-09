import 'package:flutter/material.dart';
import '../models/students.dart';
import 'student_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Student> _students = [];

  static const List<String> _weekDays = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
  ];

  Future<void> _openStudentForm() async {
    final Student? newStudent = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StudentFormPage(),
      ),
    );

    if (newStudent != null) {
      setState(() {
        _students.add(newStudent);
      });
    }
  }

  void _removeStudent(int index) {
    setState(() {
      _students.removeAt(index);
    });
  }

  Map<String, List<Map<String, String>>> _groupSchedulesByDay() {
    final Map<String, List<Map<String, String>>> grouped = {
      for (final day in _weekDays) day: [],
    };

    for (final student in _students) {
      for (final schedule in student.schedules) {
        grouped[schedule.weekDay]?.add({
          'name': student.name,
          'time': '${schedule.startHour} às ${schedule.endHour}',
        });
      }
    }

    return grouped;
  }

  Widget _buildStudentsSection() {
    if (_students.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Nenhum aluno cadastrado ainda.'),
        ),
      );
    }

    return Column(
      children: _students.asMap().entries.map((entry) {
        final int index = entry.key;
        final Student student = entry.value;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              student.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${student.schoolLevel} - ${student.schoolYear}\n'
              'Pagamento: dia ${student.paymentDay}',
            ),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _removeStudent(index),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScheduleTextBlock() {
    final groupedSchedules = _groupSchedulesByDay();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _weekDays.map((day) {
            final items = groupedSchedules[day] ?? [];

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (items.isEmpty)
                    const Text('- Nenhum aluno')
                  else
                    ...items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('- ${item['name']}: ${item['time']}'),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teaching Planner'),
        backgroundColor: const Color(0xFFF5DEB3),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openStudentForm,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Alunos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildStudentsSection(),
            const SizedBox(height: 24),
            const Text(
              'Horários por dia',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildScheduleTextBlock(),
          ],
        ),
      ),
    );
  }
}