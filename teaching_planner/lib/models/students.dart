class StudentSchedule {
  final String weekDay;
  final String startHour;
  final String endHour;

  StudentSchedule({
    required this.weekDay,
    required this.startHour,
    required this.endHour,
  });

  Map<String, dynamic> toMap() {
    return {
      'weekDay': weekDay,
      'startHour': startHour,
      'endHour': endHour,
    };
  }

  factory StudentSchedule.fromMap(Map<dynamic, dynamic> map) {
    return StudentSchedule(
      weekDay: map['weekDay'] as String,
      startHour: map['startHour'] as String,
      endHour: map['endHour'] as String,
    );
  }
}

class Student {
  final String name;
  final String schoolLevel;
  final String schoolYear;
  final int paymentDay;
  final List<StudentSchedule> schedules;

  Student({
    required this.name,
    required this.schoolLevel,
    required this.schoolYear,
    required this.paymentDay,
    required this.schedules,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'schoolLevel': schoolLevel,
      'schoolYear': schoolYear,
      'paymentDay': paymentDay,
      'schedules': schedules.map((schedule) => schedule.toMap()).toList(),
    };
  }

  factory Student.fromMap(Map<dynamic, dynamic> map) {
    return Student(
      name: map['name'] as String,
      schoolLevel: map['schoolLevel'] as String,
      schoolYear: map['schoolYear'] as String,
      paymentDay: map['paymentDay'] as int,
      schedules: (map['schedules'] as List)
          .map((item) => StudentSchedule.fromMap(item as Map<dynamic, dynamic>))
          .toList(),
    );
  }
}