class Student {
  final String name;
  final String gender;
  final String grade;
  final int classesPerWeek;
  final int paymentDay;
  final Map<String, List<String>> schedule; // Novo campo de horários

  Student({
    required this.name,
    required this.gender,
    required this.grade,
    required this.classesPerWeek,
    required this.paymentDay,
    required this.schedule,
  });
}
