import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController _priceAdjustmentController = TextEditingController();

  String? _selectedLevel;
  String? _selectedYear;
  int? _selectedClassesPerWeek;

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
  static const List<int> _classesOptions = [2, 3, 5];

  @override
  void initState() {
    super.initState();

    if (widget.student != null) {
      final student = widget.student!;

      _nameController.text = student.name;
      _paymentDayController.text = student.paymentDay.toString();
      _priceAdjustmentController.text = student.priceAdjustment.toStringAsFixed(0);
      _selectedLevel = student.schoolLevel;
      _selectedYear = student.schoolYear;
      _selectedClassesPerWeek = student.classesPerWeek;

      for (final schedule in student.schedules) {
        _scheduleControllers.add({
          'weekDay': TextEditingController(text: schedule.weekDay),
          'startHour': TextEditingController(text: schedule.startHour),
        });
      }
    }

    if (_scheduleControllers.isEmpty) {
      _scheduleControllers.add({
        'weekDay': TextEditingController(),
        'startHour': TextEditingController(),
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _paymentDayController.dispose();
    _priceAdjustmentController.dispose();

    for (final item in _scheduleControllers) {
      item['weekDay']?.dispose();
      item['startHour']?.dispose();
    }

    super.dispose();
  }

  void _addScheduleField() {
    setState(() {
      _scheduleControllers.add({
        'weekDay': TextEditingController(),
        'startHour': TextEditingController(),
      });
    });
  }

  void _removeScheduleField(int index) {
    if (_scheduleControllers.length == 1) return;

    setState(() {
      _scheduleControllers[index]['weekDay']?.dispose();
      _scheduleControllers[index]['startHour']?.dispose();
      _scheduleControllers.removeAt(index);
    });
  }

  String _calculateEndHour(String startHour) {
    final parsed = int.tryParse(startHour);
    if (parsed == null) return '';
    return '${parsed + 1}';
  }

  void _saveStudent() {
    if (!_formKey.currentState!.validate()) return;

    final List<StudentSchedule> schedules = [];

    for (final item in _scheduleControllers) {
      final weekDay = item['weekDay']!.text.trim();
      final startHour = item['startHour']!.text.trim();

      if (weekDay.isNotEmpty && startHour.isNotEmpty) {
        schedules.add(
          StudentSchedule(
            weekDay: weekDay,
            startHour: startHour,
          ),
        );
      }
    }

    final previousStudent = widget.student;

    final student = Student(
      name: _nameController.text.trim(),
      schoolLevel: _selectedLevel!,
      schoolYear: _selectedYear!,
      paymentDay: int.parse(_paymentDayController.text.trim()),
      classesPerWeek: _selectedClassesPerWeek!,
      priceAdjustment:
          double.tryParse(_priceAdjustmentController.text.trim().replaceAll(',', '.')) ?? 0.0,
      hasPaid: previousStudent?.hasPaid ?? false,
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
              value: item['weekDay']!.text.isEmpty ? null : item['weekDay']!.text,
              decoration: const InputDecoration(
                labelText: 'Dia da semana',
                border: OutlineInputBorder(),
              ),
              items: _weekDays
                  .map(
                    (day) => DropdownMenuItem(
                      value: day,
                      child: Text(day),
                    ),
                  )
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
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: 'Hora de início',
                hintText: 'Ex: 14',
                suffixText: 'h',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
              validator: (value) {
                if (index == 0 && (value == null || value.trim().isEmpty)) {
                  return 'Informe a hora de início';
                }

                final parsed = int.tryParse(value ?? '');
                if (parsed == null || parsed < 0 || parsed > 23) {
                  return 'Informe uma hora válida';
                }

                return null;
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item['startHour']!.text.trim().isEmpty
                    ? 'A aula terá duração de 1h'
                    : '${item['startHour']!.text.trim()}h às ${_calculateEndHour(item['startHour']!.text.trim())}h',
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
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
                      (level) => DropdownMenuItem(
                        value: level,
                        child: Text(level),
                      ),
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
                      (year) => DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      ),
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
              DropdownButtonFormField<int>(
                value: _selectedClassesPerWeek,
                decoration: const InputDecoration(
                  labelText: 'Dias por semana',
                  border: OutlineInputBorder(),
                ),
                items: _classesOptions
                    .map(
                      (days) => DropdownMenuItem(
                        value: days,
                        child: Text('$days dias'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedClassesPerWeek = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecione a quantidade de dias';
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
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceAdjustmentController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Alteração no valor',
                  hintText: 'Ex: 30 ou -50',
                  prefixText: 'R\$ ',
                  suffixText: ',00',
                  border: OutlineInputBorder(),
                ),
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