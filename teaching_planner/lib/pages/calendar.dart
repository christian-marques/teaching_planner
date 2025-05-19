import 'package:flutter/material.dart';
import '../services/student_service.dart';
import '../services/schedule_service.dart';
import '../models/student.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Student> students = StudentService.getStudents();
    Map<String, Map<String, List<String>>> schedules = ScheduleService.getSchedules();
    List<String> weekDays = ["Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5DEB3),
        title: const Text("Horários por Aluno", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columnSpacing: 16,
            columns: [
              const DataColumn(label: Text("Aluno", style: TextStyle(fontWeight: FontWeight.bold))),
              ...weekDays.map((day) => DataColumn(label: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)))),
            ],
            rows: students.map((student) {
              final studentSchedule = schedules[student.name] ?? {};
              return DataRow(
                cells: [
                  DataCell(Text(student.name)),
                  ...weekDays.map((day) {
                    final horarios = studentSchedule[day] ?? [];
                    return DataCell(Text(horarios.join("\n")));
                  }),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
