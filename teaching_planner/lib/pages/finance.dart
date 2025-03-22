import 'package:flutter/material.dart';
import '../services/finance_service.dart';

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de anos escolares e valores de mensalidade
    final tuitionEntries = FinanceService.tuitionFees.entries.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5DEB3),
        title: const Text("Tabela de Preços", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Permite rolagem horizontal
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
                    DataColumn(label: Text("3x por Semana", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("5x por Semana", style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: tuitionEntries.map((entry) {
                    return DataRow(cells: [
                      DataCell(Text(
                        "R\$ ${entry.value[3]?.toStringAsFixed(2) ?? "-"}",
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
    );
  }
}
