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
  String sortBy = "Nome";

  @override
  void initState() {
    super.initState();
    filteredStudents = List.from(students);
  }

  void _applyFilters(List<String> genders, List<String> grades, List<String> names, List<int> frequencies, String sort) {
    setState(() {
      selectedGenders = genders;
      selectedGrades = grades;
      selectedNames = names;
      selectedFrequencies = frequencies;
      sortBy = sort;

      filteredStudents = students.where((student) {
        bool matchesGender = selectedGenders.isEmpty || selectedGenders.contains(student.gender);
        bool matchesGrade = selectedGrades.isEmpty || selectedGrades.contains(student.grade);
        bool matchesName = selectedNames.isEmpty || selectedNames.contains(student.name);
        bool matchesFrequency = selectedFrequencies.isEmpty || selectedFrequencies.contains(student.classesPerWeek);
        return matchesGender && matchesGrade && matchesName && matchesFrequency;
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
      }
    });
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
                  selectedSort: sortBy,
                  onApplyFilters: _applyFilters,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredStudents.length,
        itemBuilder: (context, index) {
          return StudentTile(student: filteredStudents[index]);
        },
      ),
    );
  }
}
