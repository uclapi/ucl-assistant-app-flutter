class TimetableEntry {
  const TimetableEntry({
    required this.startTime,
    required this.endTime,
    required this.moduleCode,
    required this.moduleName,
    required this.lecturerName,
    required this.lecturerEmail,
    required this.location,
    required this.delivery,
  });

  final String startTime;
  final String endTime;
  final String moduleCode;
  final String moduleName;
  final String lecturerName;
  final String lecturerEmail;
  final Map location;
  final Map delivery;
}
