import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/student.dart';

class StudentFormPage extends StatefulWidget {
  const StudentFormPage({super.key});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final formKey = GlobalKey<FormState>();
  final box = Hive.box('students');
  final uuid = const Uuid();

  final nameController = TextEditingController();
  final gradeController = TextEditingController();
  final feeController = TextEditingController();
  final timeController = TextEditingController();

  final List<String> allWeekdays = const [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
  ];

  final Set<String> selectedWeekdays = {'Segunda'};

  @override
  void dispose() {
    nameController.dispose();
    gradeController.dispose();
    feeController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar aluno')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: gradeController,
                decoration: const InputDecoration(labelText: 'Ano / Série'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: feeController,
                decoration: const InputDecoration(labelText: 'Valor mensal'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text(
                'Dias da semana',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...allWeekdays.map((day) {
                final isSelected = selectedWeekdays.contains(day);
                return CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(day),
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedWeekdays.add(day);
                      } else {
                        if (selectedWeekdays.length == 1) return;
                        selectedWeekdays.remove(day);
                      }
                    });
                  },
                );
              }).toList(),
              const SizedBox(height: 12),
              TextFormField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Horário'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;

                  final student = Student(
                    id: uuid.v4(),
                    fullName: nameController.text.trim(),
                    gradeLevel: gradeController.text.trim(),
                    monthlyFee: double.tryParse(feeController.text) ?? 0,
                    weekdays: _sortWeekdays(selectedWeekdays.toList()),
                    timeSlot: timeController.text.trim(),
                  );

                  box.put(student.id, student.toMap());
                  Navigator.pop(context);
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _sortWeekdays(List<String> days) {
    days.sort((a, b) => _weekdayOrder(a).compareTo(_weekdayOrder(b)));
    return days;
  }

  int _weekdayOrder(String day) {
    switch (day) {
      case 'Segunda':
        return 1;
      case 'Terça':
        return 2;
      case 'Quarta':
        return 3;
      case 'Quinta':
        return 4;
      case 'Sexta':
        return 5;
      default:
        return 99;
    }
  }
}