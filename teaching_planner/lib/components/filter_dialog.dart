import 'package:flutter/material.dart';
import '../models/student.dart';

class FilterDialog extends StatefulWidget {
  final List<Student> students;
  final List<String> selectedGenders;
  final List<String> selectedGrades;
  final List<String> selectedNames;
  final List<int> selectedFrequencies;
  final String selectedSort;
  final Function(List<String>, List<String>, List<String>, List<int>, String) onApplyFilters;

  const FilterDialog({
    super.key,
    required this.students,
    required this.selectedGenders,
    required this.selectedGrades,
    required this.selectedNames,
    required this.selectedFrequencies,
    required this.selectedSort,
    required this.onApplyFilters,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<String> selectedGenders = [];
  List<String> selectedGrades = [];
  List<String> selectedNames = [];
  List<int> selectedFrequencies = [];
  String selectedSort = "Nome";

  bool expandGender = false;
  bool expandGrade = false;
  bool expandName = false;
  bool expandFrequency = false;

  @override
  void initState() {
    super.initState();
    selectedGenders = List.from(widget.selectedGenders);
    selectedGrades = List.from(widget.selectedGrades);
    selectedNames = List.from(widget.selectedNames);
    selectedFrequencies = List.from(widget.selectedFrequencies);
    selectedSort = widget.selectedSort;
  }

  void _toggleSelection<T>(List<T> list, T value) {
    setState(() {
      list.contains(value) ? list.remove(value) : list.add(value);
    });
  }

  void _toggleAll<T>(List<T> list, List<T> allItems) {
    setState(() {
      if (list.length == allItems.length) {
        list.clear();
      } else {
        list
          ..clear()
          ..addAll(List<T>.from(allItems)); // Correção para converter explicitamente
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> grades = widget.students.map((s) => s.grade).toSet().toList();
    List<String> names = widget.students.map((s) => s.name).toList();

    return AlertDialog(
      title: const Text("Filtrar e Classificar"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Classificação
            ExpansionTile(
              title: const Text("Classificar por:", style: TextStyle(fontWeight: FontWeight.bold)),
              children: ["Nome", "Gênero", "Ano Escolar", "Vezes na Semana", "Mensalidade"].map((sort) {
                return RadioListTile<String>(
                  title: Text(sort),
                  value: sort,
                  groupValue: selectedSort,
                  onChanged: (value) {
                    setState(() {
                      selectedSort = value!;
                    });
                  },
                );
              }).toList(),
            ),
            const Divider(),

            // Filtro de Gênero
            ExpansionTile(
              title: const Text("Filtrar por Gênero:", style: TextStyle(fontWeight: FontWeight.bold)),
              initiallyExpanded: expandGender,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _toggleAll(selectedGenders, ["Masculino", "Feminino"]),
                      child: Text(selectedGenders.length == 2 ? "Desmarcar Todos" : "Marcar Todos"),
                    ),
                  ],
                ),
                Column(
                  children: ["Masculino", "Feminino"].map((gender) {
                    return CheckboxListTile(
                      title: Text(gender),
                      value: selectedGenders.contains(gender),
                      onChanged: (_) => _toggleSelection(selectedGenders, gender),
                    );
                  }).toList(),
                ),
              ],
            ),
            const Divider(),

            // Filtro de Ano Escolar
            ExpansionTile(
              title: const Text("Filtrar por Ano Escolar:", style: TextStyle(fontWeight: FontWeight.bold)),
              initiallyExpanded: expandGrade,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _toggleAll(selectedGrades, grades),
                      child: Text(selectedGrades.length == grades.length ? "Desmarcar Todos" : "Marcar Todos"),
                    ),
                  ],
                ),
                Column(
                  children: grades.map((grade) {
                    return CheckboxListTile(
                      title: Text(grade),
                      value: selectedGrades.contains(grade),
                      onChanged: (_) => _toggleSelection(selectedGrades, grade),
                    );
                  }).toList(),
                ),
              ],
            ),
            const Divider(),

            // Filtro por Vezes na Semana
            ExpansionTile(
              title: const Text("Filtrar por Vezes na Semana:", style: TextStyle(fontWeight: FontWeight.bold)),
              initiallyExpanded: expandFrequency,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _toggleAll(selectedFrequencies, [3, 5]),
                      child: Text(selectedFrequencies.length == 2 ? "Desmarcar Todos" : "Marcar Todos"),
                    ),
                  ],
                ),
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
            const Divider(),

            // Filtro por Nome
            ExpansionTile(
              title: const Text("Filtrar por Nome:", style: TextStyle(fontWeight: FontWeight.bold)),
              initiallyExpanded: expandName,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _toggleAll(selectedNames, names),
                      child: Text(selectedNames.length == names.length ? "Desmarcar Todos" : "Marcar Todos"),
                    ),
                  ],
                ),
                Column(
                  children: names.map((name) {
                    return CheckboxListTile(
                      title: Text(name),
                      value: selectedNames.contains(name),
                      onChanged: (_) => _toggleSelection(selectedNames, name),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApplyFilters(selectedGenders, selectedGrades, selectedNames, selectedFrequencies, selectedSort);
            Navigator.pop(context);
          },
          child: const Text("Aplicar Filtros"),
        ),
      ],
    );
  }
}
