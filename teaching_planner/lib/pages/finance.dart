import 'package:flutter/material.dart';
import '../services/finance_service.dart';

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5DEB3),
        title: const Text("Tabela de Preços", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: FinanceService.tuitionFees.entries.map((entry) {
          return Card(
            child: ListTile(
              title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("3x por semana: R\$ ${entry.value[3]} • 5x por semana: R\$ ${entry.value[5]}"),
            ),
          );
        }).toList(),
      ),
    );
  }
}
