import 'package:flutter/material.dart';
import '../services/student_service.dart';
import '../services/finance_service.dart';
import '../components/student_tile.dart';
import '../components/filter_dialog.dart';
import '../models/student.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  List<Student> students = StudentService.getStudents();
  List<Student> filteredStudents = [];
  List<String> selectedGenders = [];
  List<String> selectedGrades = [];
  List<String> selectedNames = [];
  List<int> selectedFrequencies = [];
  int? selectedStartDay;
  int? selectedEndDay;
  String sortBy = "Nome";

  @override
  void initState() {
    super.initState();
    filteredStudents = List.from(students);
  }

  void _applyFilters(
      List<String> genders,
      List<String> grades,
      List<String> names,
      List<int> frequencies,
      int? startDay,
      int? endDay,
      String sort) {
    setState(() {
      selectedGenders = genders;
      selectedGrades = grades;
      selectedNames = names;
      selectedFrequencies = frequencies;
      selectedStartDay = startDay;
      selectedEndDay = endDay;
      sortBy = sort;

      filteredStudents = students.where((student) {
        bool matchesGender = selectedGenders.isEmpty || selectedGenders.contains(student.gender);
        bool matchesGrade = selectedGrades.isEmpty || selectedGrades.contains(student.grade);
        bool matchesName = selectedNames.isEmpty || selectedNames.contains(student.name);
        bool matchesFrequency = selectedFrequencies.isEmpty || selectedFrequencies.contains(student.classesPerWeek);
        bool matchesPaymentDay = (selectedStartDay == null || student.paymentDay >= selectedStartDay!) &&
            (selectedEndDay == null || student.paymentDay <= selectedEndDay!);
        return matchesGender && matchesGrade && matchesName && matchesFrequency && matchesPaymentDay;
      }).toList();

      _sortStudents();
    });
  }

  void _sortStudents() {
    setState(() {
      if (sortBy == "Nome") {
        filteredStudents.sort((a, b) => a.name.compareTo(b.name));
      } else if (sortBy == "Vezes na Semana") {
        filteredStudents.sort((a, b) => a.classesPerWeek.compareTo(b.classesPerWeek));
      } else if (sortBy == "Mensalidade") {
        filteredStudents.sort((a, b) => FinanceService.getTuitionFee(a).compareTo(FinanceService.getTuitionFee(b)));
      } else if (sortBy == "Dia de Vencimento") {
        filteredStudents.sort((a, b) => a.paymentDay.compareTo(b.paymentDay));
      }
    });
  }

  double _calculateTotal() {
    return filteredStudents.fold(0, (total, student) => total + FinanceService.getTuitionFee(student));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5DEB3),
        title: const Text("Meus Alunos", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => FilterDialog(
                  students: students,
                  selectedGenders: selectedGenders,
                  selectedGrades: selectedGrades,
                  selectedNames: selectedNames,
                  selectedFrequencies: selectedFrequencies,
                  selectedStartDay: selectedStartDay,
                  selectedEndDay: selectedEndDay,
                  selectedSort: sortBy,
                  onApplyFilters: _applyFilters,
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 70), // Espaço para o total
            child: ListView.builder(
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                return StudentTile(student: filteredStudents[index]);
              },
            ),
          ),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: Center(
                child: Text(
                  "Total: R\$ ${_calculateTotal().toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
