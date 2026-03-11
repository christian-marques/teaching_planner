import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/students.dart';
import '../services/student_storage_service.dart';
import '../utils/currency_input_formatter.dart';
import 'student_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final List<Student> _students = [];
  bool _isLoading = true;
  late TabController _tabController;
  static const List<String> _weekDays = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
  ];
  final List<String> _priceTableRows = [
    '1º Fundamental',
    '2º Fundamental',
    '3º Fundamental',
    '4º Fundamental',
    '5º Fundamental',
    '6º Fundamental',
    '7º Fundamental',
    '8º Fundamental',
    '9º Fundamental',
    '1º Médio',
    '2º Médio',
    '3º Médio',
  ];
  final Map<String, Map<int, TextEditingController>> _priceControllers = {};
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializePriceTableControllers();
    _loadStudents();
  }

  void _initializePriceTableControllers() {
    for (final row in _priceTableRows) {
      _priceControllers[row] = {
        2: TextEditingController(),
        3: TextEditingController(),
        5: TextEditingController(),
      };
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final rowMap in _priceControllers.values) {
      for (final controller in rowMap.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _loadStudents() async {
    final students = await StudentStorageService.getStudents();
    setState(() {
      _students
        ..clear()
        ..addAll(students);
      _isLoading = false;
    });
  }

  Future<void> _openStudentForm() async {
    final Student? newStudent = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const StudentFormPage()),
    );
    if (newStudent != null) {
      setState(() {
        _students.add(newStudent);
      });
      await StudentStorageService.saveStudents(_students);
    }
  }

  Future<void> _editStudent(int index) async {
    final Student? editedStudent = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentFormPage(student: _students[index]),
      ),
    );
    if (editedStudent != null) {
      setState(() {
        _students[index] = editedStudent;
      });
      await StudentStorageService.saveStudents(_students);
    }
  }

  Future<void> _removeStudent(int index) async {
    setState(() {
      _students.removeAt(index);
    });
    await StudentStorageService.saveStudents(_students);
  }

  Map<String, List<Map<String, String>>> _groupSchedulesByDay() {
    final Map<String, List<Map<String, String>>> grouped = {
      for (final day in _weekDays) day: [],
    };
    for (final student in _students) {
      for (final schedule in student.schedules) {
        grouped[schedule.weekDay]?.add({
          'name': student.name,
          'time': '${schedule.startHour} às ${schedule.endHour}',
        });
      }
    }
    return grouped;
  }

  Widget _buildStudentsSection() {
    if (_students.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Nenhum aluno cadastrado ainda.'),
        ),
      );
    }
    return Column(
      children: _students.asMap().entries.map((entry) {
        final int index = entry.key;
        final Student student = entry.value;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              student.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${student.schoolLevel} - ${student.schoolYear}\n'
              'Pagamento: dia ${student.paymentDay}',
            ),
            isThreeLine: true,
            onTap: () => _editStudent(index),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _editStudent(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _removeStudent(index),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScheduleTextBlock() {
    final groupedSchedules = _groupSchedulesByDay();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _weekDays.map((day) {
            final items = groupedSchedules[day] ?? [];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (items.isEmpty)
                    const Text('- Nenhum aluno')
                  else
                    ...items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('- ${item['name']}: ${item['time']}'),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildScheduleTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Cronograma da semana',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildScheduleTextBlock(),
      ],
    );
  }

  Widget _buildStudentsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Alunos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _openStudentForm,
              icon: const Icon(Icons.add),
              label: const Text('Novo'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildStudentsSection(),
      ],
    );
  }

  Widget _buildPendingTab() {
    return const Center(
      child: Text(
        'Quanto falta receber',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPriceInput(String rowLabel, int daysPerWeek) {
    return SizedBox(
      width: 110,
      child: TextField(
        controller: _priceControllers[rowLabel]![daysPerWeek],
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.right,
        decoration: const InputDecoration(
          prefixText: 'R\$ ',
          suffixText: ',00',
          hintText: '0',
          isDense: true,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        ),
      ),
    );
  }

  Widget _buildPriceTableTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Tabela de preços',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          'Edite os valores por ano escolar e quantidade de dias por semana.',
        ),
        const SizedBox(height: 16),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: const {
                0: FixedColumnWidth(180),
                1: FixedColumnWidth(130),
                2: FixedColumnWidth(130),
                3: FixedColumnWidth(130),
              },
              children: [
                const TableRow(
                  decoration: BoxDecoration(color: Color(0xFFF5DEB3)),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Ano escolar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          '2 dias',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          '3 dias',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          '5 dias',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                ..._priceTableRows.map(
                  (rowLabel) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          rowLabel,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildPriceInput(rowLabel, 2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildPriceInput(rowLabel, 3),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildPriceInput(rowLabel, 5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teaching Planner'),
        backgroundColor: const Color(0xFFF5DEB3),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Cronograma'),
            Tab(text: 'Alunos'),
            Tab(text: 'Falta receber'),
            Tab(text: 'Tabela de preços'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildScheduleTab(),
          _buildStudentsTab(),
          _buildPendingTab(),
          _buildPriceTableTab(),
        ],
      ),
    );
  }
}
