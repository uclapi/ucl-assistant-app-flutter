// https://stackoverflow.com/a/58492432
import 'package:url_launcher/url_launcher.dart';

String getDaySuffix(int date) {
  if (date >= 11 && date <= 13) {
    return 'th';
  }

  switch (date % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

String getMonthName(int month) {
  return [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec'
  ][month - 1];
}

String getDayName(int day) {
  return [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ][day - 1];
}

String formatTimetableDate(DateTime date) {
  return '${getDayName(date.weekday)} ${date.day}${getDaySuffix(date.day)} ${getMonthName(date.month)} ${date.year}';
}

String getDateString(DateTime date) {
  return date.toIso8601String().split('T').first;
}

DateTime getStartOfAcademicYear(DateTime date) {
  // Return 1st September
  return DateTime(date.month >= 9 ? date.year : date.year - 1, 9, 1);
}

DateTime getEndOfAcademicYear(DateTime date) {
  // Return 1st July
  return DateTime(date.month >= 9 ? date.year + 1 : date.year, 7, 1);
}

DateTime getStartOfToday() {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

// Add logical days, not 24-hour increments (which would break if we switch BST/GMT during the requested jump)
DateTime addLogicalDays(DateTime date, int days) {
  return DateTime(date.year, date.month, date.day + days, date.hour,
      date.minute, date.second, date.millisecond, date.microsecond);
}

void openMaps({String? name, double? latitude, double? longitude}) {
  if (latitude != null && longitude != null) {
    launchUrl(
        Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
        ),
        mode: LaunchMode.externalApplication);
    return;
  }

  if (name == null) return;

  launchUrl(
      Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$name',
      ),
      mode: LaunchMode.externalApplication);
}
