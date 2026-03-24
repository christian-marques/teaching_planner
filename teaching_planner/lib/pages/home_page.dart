import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/students.dart';
import '../services/student_storage_service.dart';
import '../models/price_table.dart';
import '../services/price_table_storage_service.dart';
import 'student_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
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
    _loadInitialData();
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

  Future<void> _loadInitialData() async {
    final students = await StudentStorageService.getStudents();
    final priceRows = await PriceTableStorageService.getPriceTable();

    setState(() {
      _students
        ..clear()
        ..addAll(students);

      if (priceRows.isNotEmpty) {
        for (final row in priceRows) {
          _priceControllers[row.label]?[2]?.text =
              row.price2Days == 0 ? '' : row.price2Days.toString();
          _priceControllers[row.label]?[3]?.text =
              row.price3Days == 0 ? '' : row.price3Days.toString();
          _priceControllers[row.label]?[5]?.text =
              row.price5Days == 0 ? '' : row.price5Days.toString();
        }
      }

      _isLoading = false;
    });
  }

  Future<void> _savePriceTable() async {
    final rows = _priceTableRows.map((label) {
      final price2 = int.tryParse(_priceControllers[label]![2]!.text) ?? 0;
      final price3 = int.tryParse(_priceControllers[label]![3]!.text) ?? 0;
      final price5 = int.tryParse(_priceControllers[label]![5]!.text) ?? 0;

      return PriceTableRow(
        label: label,
        price2Days: price2,
        price3Days: price3,
        price5Days: price5,
      );
    }).toList();

    await PriceTableStorageService.savePriceTable(rows);
  }

  Future<void> _openStudentForm() async {
    final Student? newStudent = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StudentFormPage(),
      ),
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

  Future<void> _togglePaid(int index, bool value) async {
    setState(() {
      _students[index] = _students[index].copyWith(hasPaid: value);
    });
    await StudentStorageService.saveStudents(_students);
  }

  String _calculateEndHour(String startHour) {
    final parsed = int.tryParse(startHour);
    if (parsed == null) return '';
    return '${parsed + 1}';
  }

  Map<String, List<Map<String, String>>> _groupSchedulesByDay() {
    final Map<String, List<Map<String, String>>> grouped = {
      for (final day in _weekDays) day: [],
    };

    for (final student in _students) {
      for (final schedule in student.schedules) {
        grouped[schedule.weekDay]?.add({
          'name': student.name,
          'time': '${schedule.startHour}h às ${_calculateEndHour(schedule.startHour)}h',
        });
      }
    }

    return grouped;
  }

  String _getPriceRowLabel(Student student) {
    if (student.schoolLevel == 'Fundamental') {
      return '${student.schoolYear} Fundamental';
    }
    return '${student.schoolYear} Médio';
  }

  double _getBasePrice(Student student) {
    final rowLabel = _getPriceRowLabel(student);
    final controller = _priceControllers[rowLabel]?[student.classesPerWeek];

    if (controller == null) return 0.0;

    final digits = controller.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return 0.0;

    return double.parse(digits);
  }

  double _getFinalPrice(Student student) {
    return _getBasePrice(student) + student.priceAdjustment;
  }

  double _getReceivedTotal() {
    return _students
        .where((student) => student.hasPaid)
        .fold(0.0, (sum, student) => sum + _getFinalPrice(student));
  }

  double _getPendingTotal() {
    return _students
        .where((student) => !student.hasPaid)
        .fold(0.0, (sum, student) => sum + _getFinalPrice(student));
  }

  String _formatCurrency(double value) {
    final isNegative = value < 0;
    final absValue = value.abs().toStringAsFixed(0);
    return '${isNegative ? '-' : ''}R\$ $absValue,00';
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
    if (_students.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum aluno cadastrado.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
          child: ListView.builder(
            itemCount: _students.length,
            itemBuilder: (context, index) {
              final student = _students[index];
              final finalPrice = _getFinalPrice(student);

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: CheckboxListTile(
                  value: student.hasPaid,
                  onChanged: (value) {
                    if (value != null) {
                      _togglePaid(index, value);
                    }
                  },
                  title: Text(
                    student.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${student.schoolLevel} - ${student.schoolYear}\n'
                    '${_formatCurrency(finalPrice)}',
                  ),
                  isThreeLine: true,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              );
            },
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Row(
            children: [
              Expanded(
                child: _buildTotalCard(
                  title: 'Já recebi',
                  value: _formatCurrency(_getReceivedTotal()),
                  backgroundColor: const Color(0xFFF5DEB3),
                  textColor: Colors.black87,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTotalCard(
                  title: 'Falta receber',
                  value: _formatCurrency(_getPendingTotal()),
                  backgroundColor: Colors.green.shade700,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalCard({
    required String title,
    required String value,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.85),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPriceInput(String rowLabel, int daysPerWeek) {
    return SizedBox(
      width: 125,
      child: TextField(
        controller: _priceControllers[rowLabel]![daysPerWeek],
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        textAlign: TextAlign.right,
        decoration: const InputDecoration(
          prefixText: 'R\$ ',
          suffixText: ',00',
          hintText: '0',
          isDense: true,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        ),
        onChanged: (_) async {
          setState(() {});
          await _savePriceTable();
        },
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
                  decoration: BoxDecoration(
                    color: Color(0xFFF5DEB3),
                  ),
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
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
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