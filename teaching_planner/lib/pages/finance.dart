import 'package:flutter/material.dart';
import '../services/finance_service.dart';
import '../services/student_service.dart';
import '../models/student.dart';

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  double _calculateTotal(List<Student> students) {
    return students.fold(0, (total, student) => total + FinanceService.getTuitionFee(student) - FinanceService.getDiscount(student));
  }

  @override
  Widget build(BuildContext context) {
    final students = StudentService.getStudents();
    final tuitionEntries = FinanceService.tuitionFees.entries.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5DEB3),
        title: const Text("Tabela de Preços", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Tabela rolável
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coluna fixa: Ano Escolar
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.grey[400]!, width: 1),
                      ),
                    ),
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[300]!),
                      columns: const [
                        DataColumn(label: Text("Ano Escolar", style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: tuitionEntries.map((entry) {
                        return DataRow(cells: [
                          DataCell(Text(entry.key, style: const TextStyle(fontSize: 16))),
                        ]);
                      }).toList(),
                    ),
                  ),

                  // Tabela deslizável
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[300]!),
                      columns: const [
                        DataColumn(label: Text("2x por Semana", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("3x por Semana", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("4x por Semana", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("5x por Semana", style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: tuitionEntries.map((entry) {
                        return DataRow(cells: [
                          DataCell(Text(
                            "R\$ ${entry.value[2]?.toStringAsFixed(2) ?? "-"}",
                            style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                          )),
                          DataCell(Text(
                            "R\$ ${entry.value[3]?.toStringAsFixed(2) ?? "-"}",
                            style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                          )),
                          DataCell(Text(
                            "R\$ ${entry.value[4]?.toStringAsFixed(2) ?? "-"}",
                            style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                          )),
                          DataCell(Text(
                            "R\$ ${entry.value[5]?.toStringAsFixed(2) ?? "-"}",
                            style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Total fixo colado no final da tela
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, -2)),
              ],
            ),
            child: Center(
              child: Text(
                "Total: R\$ ${_calculateTotal(students).toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
