import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentTile extends StatelessWidget {
  final Student student;

  const StudentTile({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        student.gender == "Masculino" ? Icons.boy : Icons.girl,
        color: student.gender == "Masculino" ? Colors.blue : Colors.pink,
        size: 40,
      ),
      title: Text(
        student.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(student.grade),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}
