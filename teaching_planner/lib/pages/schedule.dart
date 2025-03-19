import 'package:flutter/material.dart';
import '../services/student_service.dart';
import '../models/student.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Student> students = StudentService.getStudents();

    // Criando os horários de 30 em 30 minutos
    List<String> timeSlots = [];
    for (int hour = 8; hour < 20; hour++) {
      timeSlots.add("$hour:00 - $hour:30");
      if (hour < 19) timeSlots.add("$hour:30 - ${hour + 1}:00");
    }

    List<String> weekDays = ["Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira"]; // Ajustado

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5DEB3),
        title: const Text("Grade Horária", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical, // Permite rolagem vertical
          child: Column(
            children: [
              // Cabeçalho da tabela
              Row(
                children: [
                  const SizedBox(width: 120), // Espaço para a coluna de horários
                  for (var day in weekDays)
                    Container(
                      width: 140,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(child: Text(day, style: const TextStyle(fontWeight: FontWeight.bold))),
                    ),
                ],
              ),

              // Linhas de horários
              for (var time in timeSlots)
                Row(
                  children: [
                    // Coluna fixa com os horários
                    Container(
                      width: 120,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(child: Text(time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                    ),

                    // Criando as células para cada dia
                    for (var day in weekDays)
                      Container(
                        width: 140,
                        height: 50, // Ajuste de altura para melhor visualização
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _getStudentForSlot(students, day, time),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getStudentForSlot(List<Student> students, String day, String time) {
    List<Student> studentsInSlot = students.where((student) {
      return student.schedule.containsKey(day) && student.schedule[day]!.contains(time);
    }).toList();

    if (studentsInSlot.isEmpty) {
      return const SizedBox.shrink(); // Espaço vazio se ninguém estiver nesse horário
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: studentsInSlot
          .map((student) => Text(
                student.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ))
          .toList(),
    );
  }
}
