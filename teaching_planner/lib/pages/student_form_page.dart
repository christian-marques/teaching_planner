import 'package:flutter/material.dart';
import '../models/students.dart';

class StudentFormPage extends StatefulWidget {
  final Student? student;
  const StudentFormPage({super.key, this.student});
  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _paymentDayController = TextEditingController();
  String? _selectedLevel;
  String? _selectedYear;
  final List<Map<String, TextEditingController>> _scheduleControllers = [];
  static const List<String> _levels = ['Fundamental', 'Médio'];
  static const List<String> _years = [
    '1º',
    '2º',
    '3º',
    '4º',
    '5º',
    '6º',
    '7º',
    '8º',
    '9º',
  ];
  static const List<String> _weekDays = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
  ];
  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      final student = widget.student!;
      _nameController.text = student.name;
      _paymentDayController.text = student.paymentDay.toString();
      _selectedLevel = student.schoolLevel;
      _selectedYear = student.schoolYear;
      for (final schedule in student.schedules) {
        _scheduleControllers.add({
          'weekDay': TextEditingController(text: schedule.weekDay),
          'startHour': TextEditingController(text: schedule.startHour),
          'endHour': TextEditingController(text: schedule.endHour),
        });
      }
    }
    if (_scheduleControllers.isEmpty) {
      _scheduleControllers.add({
        'weekDay': TextEditingController(),
        'startHour': TextEditingController(),
        'endHour': TextEditingController(),
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _paymentDayController.dispose();
    for (final item in _scheduleControllers) {
      item['weekDay']?.dispose();
      item['startHour']?.dispose();
      item['endHour']?.dispose();
    }
    super.dispose();
  }

  void _addScheduleField() {
    setState(() {
      _scheduleControllers.add({
        'weekDay': TextEditingController(),
        'startHour': TextEditingController(),
        'endHour': TextEditingController(),
      });
    });
  }

  void _removeScheduleField(int index) {
    if (_scheduleControllers.length == 1) return;
    setState(() {
      _scheduleControllers[index]['weekDay']?.dispose();
      _scheduleControllers[index]['startHour']?.dispose();
      _scheduleControllers[index]['endHour']?.dispose();
      _scheduleControllers.removeAt(index);
    });
  }

  void _saveStudent() {
    if (!_formKey.currentState!.validate()) return;
    final List<StudentSchedule> schedules = [];
    for (final item in _scheduleControllers) {
      final weekDay = item['weekDay']!.text.trim();
      final startHour = item['startHour']!.text.trim();
      final endHour = item['endHour']!.text.trim();
      if (weekDay.isNotEmpty && startHour.isNotEmpty && endHour.isNotEmpty) {
        schedules.add(
          StudentSchedule(
            weekDay: weekDay,
            startHour: startHour,
            endHour: endHour,
          ),
        );
      }
    }
    final student = Student(
      name: _nameController.text.trim(),
      schoolLevel: _selectedLevel!,
      schoolYear: _selectedYear!,
      paymentDay: int.parse(_paymentDayController.text.trim()),
      schedules: schedules,
    );
    Navigator.pop(context, student);
  }

  Widget _buildScheduleItem(int index) {
    final item = _scheduleControllers[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: item['weekDay']!.text.isEmpty
                  ? null
                  : item['weekDay']!.text,
              decoration: const InputDecoration(
                labelText: 'Dia da semana',
                border: OutlineInputBorder(),
              ),
              items: _weekDays
                  .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                  .toList(),
              onChanged: (value) {
                item['weekDay']!.text = value ?? '';
              },
              validator: (value) {
                if (index == 0 && (value == null || value.isEmpty)) {
                  return 'Selecione o dia';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: item['startHour'],
              decoration: const InputDecoration(
                labelText: 'Hora de início',
                hintText: 'Ex: 14h',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (index == 0 && (value == null || value.trim().isEmpty)) {
                  return 'Informe a hora de início';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: item['endHour'],
              decoration: const InputDecoration(
                labelText: 'Hora de fim',
                hintText: 'Ex: 16h',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (index == 0 && (value == null || value.trim().isEmpty)) {
                  return 'Informe a hora de fim';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _removeScheduleField(index),
                icon: const Icon(Icons.remove_circle_outline),
                label: const Text('Remover horário'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.student != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar aluno' : 'Novo aluno'),
        backgroundColor: const Color(0xFFF5DEB3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedLevel,
                decoration: const InputDecoration(
                  labelText: 'Nível',
                  border: OutlineInputBorder(),
                ),
                items: _levels
                    .map(
                      (level) =>
                          DropdownMenuItem(value: level, child: Text(level)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLevel = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o nível';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedYear,
                decoration: const InputDecoration(
                  labelText: 'Série/Ano',
                  border: OutlineInputBorder(),
                ),
                items: _years
                    .map(
                      (year) =>
                          DropdownMenuItem(value: year, child: Text(year)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedYear = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione a série';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _paymentDayController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Dia de pagamento',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o dia de pagamento';
                  }
                  final paymentDay = int.tryParse(value);
                  if (paymentDay == null || paymentDay < 1 || paymentDay > 31) {
                    return 'Informe um dia válido entre 1 e 31';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Horários de ensino',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._scheduleControllers.asMap().entries.map(
                (entry) => _buildScheduleItem(entry.key),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: _addScheduleField,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar horário'),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveStudent,
                child: Text(isEditing ? 'Salvar alterações' : 'Salvar aluno'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
