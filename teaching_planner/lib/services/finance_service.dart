import '../models/student.dart';

class FinanceService {
  static Map<String, Map<int, double>> tuitionFees = {
    "1º Ano":               {2: 110.0, 3: 110.0, 4: 130.0, 5: 160.0},
    "2º Ano":               {2: 110.0, 3: 110.0, 4: 130.0, 5: 160.0},
    "3º Ano":               {2: 110.0, 3: 110.0, 4: 130.0, 5: 160.0},
    "4º Ano":               {2: 120.0, 3: 120.0, 4: 140.0, 5: 170.0},
    "5º Ano":               {2: 120.0, 3: 120.0, 4: 140.0, 5: 170.0},
    "6º Ano":               {2: 130.0, 3: 130.0, 4: 150.0, 5: 180.0},
    "7º Ano":               {2: 120.0, 3: 140.0, 4: 160.0, 5: 200.0},
    "8º Ano":               {2: 130.0, 3: 150.0, 4: 170.0, 5: 200.0},
    "9º Ano":               {2: 130.0, 3: 150.0, 4: 170.0, 5: 200.0},
    "1º Ano Ensino Médio":  {2: 180.0, 3: 180.0, 4: 200.0, 5: 250.0},
    "2º Ano Ensino Médio":  {2: 180.0, 3: 180.0, 4: 200.0, 5: 250.0},
  };

  static double getTuitionFee(Student student) {
    return tuitionFees[student.grade]?[student.classesPerWeek] ?? 150.0;
  }

  static double getDiscount(Student student) {
    return student.discount;
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
