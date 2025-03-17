import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/finance_service.dart';

class StudentTile extends StatelessWidget {
  final Student student;

  const StudentTile({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Icon(
          student.gender == "Masculino" ? Icons.boy : Icons.girl,
          color: student.gender == "Masculino" ? Colors.blue : Colors.pink,
        ),
        title: Text(student.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text("${student.grade} • ${student.classesPerWeek}x por semana"),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "R\$ ${FinanceService.getTuitionFee(student).toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            Text(
              "Venc: dia ${student.paymentDay}",
              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
