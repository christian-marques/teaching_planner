import 'package:hive_flutter/hive_flutter.dart';
import '../models/students.dart';

class StudentStorageService {
  static const String boxName = 'students_box';
  static const String studentsKey = 'students_list';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  static Future<List<Student>> getStudents() async {
    final box = Hive.box(boxName);
    final rawList = box.get(studentsKey, defaultValue: []) as List;

    return rawList
        .map((item) => Student.fromMap(Map<dynamic, dynamic>.from(item as Map)))
        .toList();
  }

  static Future<void> saveStudents(List<Student> students) async {
    final box = Hive.box(boxName);
    final data = students.map((student) => student.toMap()).toList();
    await box.put(studentsKey, data);
  }
}