import 'package:flutter/material.dart';
import '../models/student.dart';

class FilterFinanceDialog extends StatefulWidget {
  final List<Student> students;
  final List<int> selectedFrequencies;
  final List<String> selectedGrades;
  final Function(List<int>, List<String>) onApplyFilters;

  const FilterFinanceDialog({
    super.key,
    required this.students,
    required this.selectedFrequencies,
    required this.selectedGrades,
    required this.onApplyFilters,
  });

  @override
  State<FilterFinanceDialog> createState() => _FilterFinanceDialogState();
}

class _FilterFinanceDialogState extends State<FilterFinanceDialog> {
  List<int> selectedFrequencies = [];
  List<String> selectedGrades = [];

  @override
  void initState() {
    super.initState();
    selectedFrequencies = List.from(widget.selectedFrequencies);
    selectedGrades = List.from(widget.selectedGrades);
  }

  void _toggleSelection(List list, dynamic value) {
    setState(() {
      list.contains(value) ? list.remove(value) : list.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> grades = widget.students.map((s) => s.grade).toSet().toList();

    return AlertDialog(
      title: const Text("Filtrar Finanças"),
      content: Column(
        children: [
          const Text("Aulas por Semana:"),
          CheckboxListTile(
            title: const Text("3x por semana"),
            value: selectedFrequencies.contains(3),
            onChanged: (_) => _toggleSelection(selectedFrequencies, 3),
          ),
          CheckboxListTile(
            title: const Text("5x por semana"),
            value: selectedFrequencies.contains(5),
            onChanged: (_) => _toggleSelection(selectedFrequencies, 5),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            widget.onApplyFilters(selectedFrequencies, selectedGrades);
            Navigator.pop(context);
          },
          child: const Text("Aplicar Filtros"),
        ),
      ],
    );
  }
}
