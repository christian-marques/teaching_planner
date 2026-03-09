class StudentSchedule {
  final String weekDay;
  final String startHour;
  final String endHour;

  StudentSchedule({
    required this.weekDay,
    required this.startHour,
    required this.endHour,
  });
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
}