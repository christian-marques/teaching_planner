import '../models/student.dart';

class StudentService {
  static List<Student> getStudents() {
    return [
      Student(name: "João Miguel",    gender: "Masculino",  grade: "3º Ano",                classesPerWeek: 3,  paymentDay: 10),
      Student(name: "Nicolly",        gender: "Feminino",   grade: "7º Ano",                classesPerWeek: 3,  paymentDay: 11),
      Student(name: "Enzo",           gender: "Masculino",  grade: "7º Ano",                classesPerWeek: 3,  paymentDay: 5),
      Student(name: "Wesley",         gender: "Masculino",  grade: "9º Ano",                classesPerWeek: 3,  paymentDay: 13),
      Student(name: "Andrey",         gender: "Masculino",  grade: "8º Ano",                classesPerWeek: 3,  paymentDay: 20),
      Student(name: "Anderson",       gender: "Masculino",  grade: "1º Ano Ensino Médio",   classesPerWeek: 3,  paymentDay: 20),
      Student(name: "Maria Eduarda",  gender: "Feminino",   grade: "9º Ano",                classesPerWeek: 3,  paymentDay: 11),
      Student(name: "Kauê",           gender: "Masculino",  grade: "6º Ano",                classesPerWeek: 3,  paymentDay: 5),
      Student(name: "Emilly",         gender: "Feminino",   grade: "1º Ano",                classesPerWeek: 5,  paymentDay: 16),
      Student(name: "Maria Clara",    gender: "Feminino",   grade: "7º Ano",                classesPerWeek: 3,  paymentDay: 11),
    ];
  }
}
