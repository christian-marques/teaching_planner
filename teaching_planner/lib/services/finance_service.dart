import '../models/student.dart';

class FinanceService {
  static Map<String, Map<int, double>> tuitionFees = {
    "1º Ano": {3: 110.0, 5: 160.0},
    "2º Ano": {3: 110.0, 5: 160.0},
    "3º Ano": {3: 110.0, 5: 160.0},
    "4º Ano": {3: 120.0, 5: 170.0},
    "5º Ano": {3: 120.0, 5: 170.0},
    "6º Ano": {3: 130.0, 5: 180.0},
    "7º Ano": {3: 140.0, 5: 200.0},
    "8º Ano": {3: 150.0, 5: 200.0},
    "9º Ano": {3: 150.0, 5: 200.0},
    "1º Ano Ensino Médio": {3: 180.0, 5: 250.0},
    "2º Ano Ensino Médio": {3: 180.0, 5: 250.0},
  };

  static double getTuitionFee(Student student) {
    return tuitionFees[student.grade]?[student.classesPerWeek] ?? 150.0;
  }

  static double getTotalRevenue(List<Student> students) {
    return students.fold(0, (total, student) => total + getTuitionFee(student));
  }

  static void updateTuitionFee(String grade, int classesPerWeek, double newFee) {
    if (tuitionFees.containsKey(grade)) {
      tuitionFees[grade]![classesPerWeek] = newFee;
    }
  }
}
