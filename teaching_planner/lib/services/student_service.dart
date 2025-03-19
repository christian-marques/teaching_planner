import '../models/student.dart';

class StudentService {
  static List<Student> getStudents() {
    return [
      Student(
        name: "João Miguel",
        gender: "Masculino",
        grade: "3º Ano",
        classesPerWeek: 3,
        paymentDay: 10,
        schedule: {
          "Segunda-feira": ["08:00 - 08:30", "10:00 - 10:30"],
          "Quarta-feira": ["09:00 - 09:30"],
          "Sexta-feira": ["14:00 - 14:30"]
        },
      ),
      Student(
        name: "Nicolly",
        gender: "Feminino",
        grade: "7º Ano",
        classesPerWeek: 3,
        paymentDay: 11,
        schedule: {
          "Terça-feira": ["08:30 - 09:00", "11:00 - 11:30"],
          "Quinta-feira": ["10:30 - 11:00"],
          "Sexta-feira": ["15:00 - 15:30"]
        },
      ),
      Student(
        name: "Enzo",
        gender: "Masculino",
        grade: "7º Ano",
        classesPerWeek: 3,
        paymentDay: 5,
        schedule: {
          "Segunda-feira": ["09:00 - 09:30", "10:30 - 11:00"],
          "Quarta-feira": ["14:00 - 14:30"],
          "Sexta-feira": ["16:00 - 16:30"]
        },
      ),
      Student(
        name: "Wesley",
        gender: "Masculino",
        grade: "9º Ano",
        classesPerWeek: 3,
        paymentDay: 13,
        schedule: {
          "Terça-feira": ["08:00 - 08:30", "09:30 - 10:00"],
          "Quarta-feira": ["11:30 - 12:00"],
          "Sexta-feira": ["15:30 - 16:00"]
        },
      ),
      Student(
        name: "Andrey",
        gender: "Masculino",
        grade: "8º Ano",
        classesPerWeek: 3,
        paymentDay: 20,
        schedule: {
          "Segunda-feira": ["10:00 - 10:30"],
          "Quarta-feira": ["14:30 - 15:00"],
          "Sexta-feira": ["17:00 - 17:30"]
        },
      ),
      Student(
        name: "Anderson",
        gender: "Masculino",
        grade: "1º Ano Ensino Médio",
        classesPerWeek: 3,
        paymentDay: 20,
        schedule: {
          "Segunda-feira": ["11:00 - 11:30"],
          "Quinta-feira": ["16:30 - 17:00"],
          "Sexta-feira": ["18:00 - 18:30"]
        },
      ),
      Student(
        name: "Maria Eduarda",
        gender: "Feminino",
        grade: "9º Ano",
        classesPerWeek: 3,
        paymentDay: 11,
        schedule: {
          "Segunda-feira": ["09:30 - 10:00"],
          "Terça-feira": ["11:00 - 11:30"],
          "Sexta-feira": ["17:30 - 18:00"]
        },
      ),
      Student(
        name: "Kauê",
        gender: "Masculino",
        grade: "6º Ano",
        classesPerWeek: 3,
        paymentDay: 5,
        schedule: {
          "Terça-feira": ["08:30 - 09:00", "10:30 - 11:00"],
          "Quinta-feira": ["15:00 - 15:30"],
        },
      ),
      Student(
        name: "Emilly",
        gender: "Feminino",
        grade: "1º Ano",
        classesPerWeek: 5,
        paymentDay: 16,
        schedule: {
          "Segunda-feira": ["08:00 - 08:30", "09:30 - 10:00"],
          "Terça-feira": ["11:30 - 12:00"],
          "Quarta-feira": ["14:30 - 15:00"],
          "Quinta-feira": ["16:30 - 17:00"],
          "Sexta-feira": ["18:00 - 18:30"]
        },
      ),
      Student(
        name: "Maria Clara",
        gender: "Feminino",
        grade: "7º Ano",
        classesPerWeek: 3,
        paymentDay: 11,
        schedule: {
          "Segunda-feira": ["08:30 - 09:00"],
          "Quarta-feira": ["09:30 - 10:00"],
          "Sexta-feira": ["14:30 - 15:00"]
        },
      ),
    ];
  }
}
