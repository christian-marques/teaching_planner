import 'package:flutter/material.dart';
import '../services/student_service.dart';
import '../services/finance_service.dart';
import '../components/finance_tile.dart';
import '../components/filter_finance_dialog.dart';
import '../models/student.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  List<Student> students = StudentService.getStudents();
  List<Student> filteredStudents = [];
  List<int> selectedFrequencies = [];
  List<String> selectedGrades = [];

  @override
  void initState() {
    super.initState();
    filteredStudents = List.from(students);
  }

  void _applyFilters(List<int> frequencies, List<String> grades) {
    setState(() {
      selectedFrequencies = frequencies;
      selectedGrades = grades;

      filteredStudents = students.where((student) {
        bool matchesFrequency = selectedFrequencies.isEmpty || selectedFrequencies.contains(student.classesPerWeek);
        bool matchesGrade = selectedGrades.isEmpty || selectedGrades.contains(student.grade);
        return matchesFrequency && matchesGrade;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5DEB3), // Bege
        title: const Text("Finanças", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => FilterFinanceDialog(
                  students: students,
                  selectedFrequencies: selectedFrequencies,
                  selectedGrades: selectedGrades,
                  onApplyFilters: _applyFilters,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Total a Receber: R\$ ${FinanceService.getTotalRevenue(filteredStudents).toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                return FinanceTile(student: filteredStudents[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
