import 'package:flutter/material.dart';
import '../models/student.dart';

class FilterDialog extends StatefulWidget {
  final List<Student> students;
  final List<String> selectedGenders;
  final List<String> selectedGrades;
  final List<String> selectedNames;
  final List<int> selectedFrequencies;
  final int? selectedStartDay;
  final int? selectedEndDay;
  final String selectedSort;
  final Function(List<String>, List<String>, List<String>, List<int>, int?, int?, String) onApplyFilters;

  const FilterDialog({
    super.key,
    required this.students,
    required this.selectedGenders,
    required this.selectedGrades,
    required this.selectedNames,
    required this.selectedFrequencies,
    required this.selectedStartDay,
    required this.selectedEndDay,
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
  int? selectedStartDay;
  int? selectedEndDay;
  String selectedSort = "Nome";

  bool expandGender = false;
  bool expandGrade = false;
  bool expandName = false;
  bool expandFrequency = false;
  bool expandPaymentDay = false;

  final TextEditingController _startDayController = TextEditingController();
  final TextEditingController _endDayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedGenders = List.from(widget.selectedGenders);
    selectedGrades = List.from(widget.selectedGrades);
    selectedNames = List.from(widget.selectedNames);
    selectedFrequencies = List.from(widget.selectedFrequencies);
    selectedStartDay = widget.selectedStartDay;
    selectedEndDay = widget.selectedEndDay;
    selectedSort = widget.selectedSort;

    // Inicializa os campos de texto com os valores atuais, se existirem
    _startDayController.text = selectedStartDay?.toString() ?? "";
    _endDayController.text = selectedEndDay?.toString() ?? "";
  }

  @override
  void dispose() {
    _startDayController.dispose();
    _endDayController.dispose();
    super.dispose();
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
          ..addAll(List<T>.from(allItems));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> grades = widget.students.map((s) => s.grade).toSet().toList();
    // List<String> names = widget.students.map((s) => s.name).toList();

    return AlertDialog(
      title: const Text("Filtrar e Classificar"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Classificação
            ExpansionTile(
              title: const Text("Classificar por:", style: TextStyle(fontWeight: FontWeight.bold)),
              children: ["Nome", "Gênero", "Ano Escolar", "Vezes na Semana", "Mensalidade", "Dia de Vencimento"]
                  .map((sort) {
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
                      onPressed: () => _toggleAll(selectedFrequencies, [2, 3, 4, 5]),
                      child: Text(selectedFrequencies.length == 4 ? "Desmarcar Todos" : "Marcar Todos"),
                    ),
                  ],
                ),
                CheckboxListTile(
                  title: const Text("2x por semana"),
                  value: selectedFrequencies.contains(2),
                  onChanged: (_) => _toggleSelection(selectedFrequencies, 2),
                ),
                CheckboxListTile(
                  title: const Text("3x por semana"),
                  value: selectedFrequencies.contains(3),
                  onChanged: (_) => _toggleSelection(selectedFrequencies, 3),
                ),
                CheckboxListTile(
                  title: const Text("4x por semana"),
                  value: selectedFrequencies.contains(4),
                  onChanged: (_) => _toggleSelection(selectedFrequencies, 4),
                ),
                CheckboxListTile(
                  title: const Text("5x por semana"),
                  value: selectedFrequencies.contains(5),
                  onChanged: (_) => _toggleSelection(selectedFrequencies, 5),
                ),
              ],
            ),
            const Divider(),

            // Filtro por Intervalo de Dias de Vencimento
            ExpansionTile(
              title: const Text("Filtrar por Vencimento:", style: TextStyle(fontWeight: FontWeight.bold)),
              initiallyExpanded: expandPaymentDay,
              children: [
                Row(
                  children: [
                    const Text("Início:"),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _startDayController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Ex: 5"),
                        onChanged: (value) {
                          setState(() {
                            selectedStartDay = int.tryParse(value);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Fim:"),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _endDayController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Ex: 20"),
                        onChanged: (value) {
                          setState(() {
                            selectedEndDay = int.tryParse(value);
                          });
                        },
                      ),
                    ),
                  ],
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
            widget.onApplyFilters(selectedGenders, selectedGrades, selectedNames, selectedFrequencies, selectedStartDay,
                selectedEndDay, selectedSort);
            Navigator.pop(context);
          },
          child: const Text("Aplicar Filtros"),
        ),
      ],
    );
  }
}
