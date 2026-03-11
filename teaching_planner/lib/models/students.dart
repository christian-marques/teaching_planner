class StudentSchedule {
  final String weekDay;
  final String startHour;

  StudentSchedule({
    required this.weekDay,
    required this.startHour,
  });

  Map<String, dynamic> toMap() {
    return {
      'weekDay': weekDay,
      'startHour': startHour,
    };
  }

  factory StudentSchedule.fromMap(Map<dynamic, dynamic> map) {
    return StudentSchedule(
      weekDay: map['weekDay'] as String,
      startHour: map['startHour'] as String,
    );
  }
}

class Student {
  final String name;
  final String schoolLevel;
  final String schoolYear;
  final int paymentDay;
  final int classesPerWeek;
  final double priceAdjustment;
  final bool hasPaid;
  final List<StudentSchedule> schedules;

  Student({
    required this.name,
    required this.schoolLevel,
    required this.schoolYear,
    required this.paymentDay,
    required this.classesPerWeek,
    required this.priceAdjustment,
    required this.hasPaid,
    required this.schedules,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'schoolLevel': schoolLevel,
      'schoolYear': schoolYear,
      'paymentDay': paymentDay,
      'classesPerWeek': classesPerWeek,
      'priceAdjustment': priceAdjustment,
      'hasPaid': hasPaid,
      'schedules': schedules.map((schedule) => schedule.toMap()).toList(),
    };
  }

  factory Student.fromMap(Map<dynamic, dynamic> map) {
    return Student(
      name: map['name'] as String,
      schoolLevel: map['schoolLevel'] as String,
      schoolYear: map['schoolYear'] as String,
      paymentDay: map['paymentDay'] as int,
      classesPerWeek: (map['classesPerWeek'] as int?) ?? 3,
      priceAdjustment: (map['priceAdjustment'] as num?)?.toDouble() ?? 0.0,
      hasPaid: (map['hasPaid'] as bool?) ?? false,
      schedules: (map['schedules'] as List)
          .map((item) => StudentSchedule.fromMap(item as Map<dynamic, dynamic>))
          .toList(),
    );
  }

  Student copyWith({
    String? name,
    String? schoolLevel,
    String? schoolYear,
    int? paymentDay,
    int? classesPerWeek,
    double? priceAdjustment,
    bool? hasPaid,
    List<StudentSchedule>? schedules,
  }) {
    return Student(
      name: name ?? this.name,
      schoolLevel: schoolLevel ?? this.schoolLevel,
      schoolYear: schoolYear ?? this.schoolYear,
      paymentDay: paymentDay ?? this.paymentDay,
      classesPerWeek: classesPerWeek ?? this.classesPerWeek,
      priceAdjustment: priceAdjustment ?? this.priceAdjustment,
      hasPaid: hasPaid ?? this.hasPaid,
      schedules: schedules ?? this.schedules,
    );
  }
}