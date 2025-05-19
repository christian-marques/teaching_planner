import '../models/student.dart';

class StudentService {
  static List<Student> getStudents() {
    return [
      Student(name: "Nicolly",          gender: "Feminino",   grade: "7º Ano",                classesPerWeek: 3,  paymentDay: 11, discount: 0.0),
      Student(name: "Enzo",             gender: "Masculino",  grade: "7º Ano",                classesPerWeek: 3,  paymentDay: 05, discount: 0.0),
      Student(name: "Wesley 1",         gender: "Masculino",  grade: "9º Ano",                classesPerWeek: 3,  paymentDay: 13, discount: 0.0),
      Student(name: "Andrey",           gender: "Masculino",  grade: "8º Ano",                classesPerWeek: 3,  paymentDay: 20, discount: 0.0),
      Student(name: "Anderson",         gender: "Masculino",  grade: "1º Ano Ensino Médio",   classesPerWeek: 3,  paymentDay: 20, discount: 0.0),
      Student(name: "Maria Eduarda",    gender: "Feminino",   grade: "9º Ano",                classesPerWeek: 3,  paymentDay: 11, discount: 0.0),
      Student(name: "Kauê",             gender: "Masculino",  grade: "6º Ano",                classesPerWeek: 3,  paymentDay: 05, discount: 0.0),
      Student(name: "Emilly",           gender: "Feminino",   grade: "1º Ano",                classesPerWeek: 5,  paymentDay: 16, discount: 0.0),
      Student(name: "Maria Clara",      gender: "Feminino",   grade: "7º Ano",                classesPerWeek: 3,  paymentDay: 11, discount: 0.0),
      Student(name: "Wesley 2",         gender: "Masculino",  grade: "6º Ano",                classesPerWeek: 3,  paymentDay: 24, discount: 0.0),
      Student(name: "Kaique",           gender: "Masculino",  grade: "5º Ano",                classesPerWeek: 4,  paymentDay: 01, discount: -10.0),
      Student(name: "Manuella",         gender: "Feminino",   grade: "7º Ano",                classesPerWeek: 3,  paymentDay: 15, discount: 0.0),
      Student(name: "Juninho",          gender: "Masculino",  grade: "3º Ano",                classesPerWeek: 3,  paymentDay: 15, discount: 0.0),
      Student(name: "João Guilherme",   gender: "Masculino",  grade: "1º Ano",                classesPerWeek: 3,  paymentDay: 15, discount: 0.0),
      Student(name: "Yara",             gender: "Feminino",   grade: "4º Ano",                classesPerWeek: 3,  paymentDay: 19, discount: -50.0),
    ];
  }
}
