import 'package:flutter/material.dart';
import 'package:ucl_assistant/api/api.dart';
import 'package:ucl_assistant/helpers.dart';
import 'package:ucl_assistant/models/timetable_entry.dart';
import 'package:ucl_assistant/widgets/error_message.dart';
import 'package:ucl_assistant/widgets/gradient_button.dart';
import 'package:ucl_assistant/widgets/loading.dart';
import 'package:ucl_assistant/widgets/timetable_day.dart';
import 'package:ucl_assistant/widgets/undraw_image.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  late DateTime fromDate;
  String? errorMessage;
  bool loading = true;
  Map<String, List<TimetableEntry>> timetableEntries = {};

  void fetchData() {
    setState(() {
      loading = true;
    });

    API()
        .timetable()
        .getPersonalTimetable(fromDate.toIso8601String().split('T').first)
        .then(
          (timetable) => setState(() {
            timetableEntries = timetable;
            errorMessage = null;
            loading = false;
          }),
        )
        .catchError((e) => setState(() {
              errorMessage = e;
            }));
  }

  void setDate(DateTime date) {
    setState(() {
      fromDate = date;
    });
    fetchData();
  }

  void changeWeek(int incrementWeeks) {
    setDate(addLogicalDays(fromDate, incrementWeeks * 7));
  }

  void handleJumpToDate() async {
    final DateTime? pickedDate = await showDatePicker(
      builder: (ctxt, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: child!,
      ),
      context: context,
      initialDate: fromDate,
      firstDate: getStartOfAcademicYear(fromDate),
      lastDate: getEndOfAcademicYear(fromDate),
      selectableDayPredicate: (day) => day.weekday == 1,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate == null) return;
    setDate(pickedDate);
  }

  @override
  void initState() {
    super.initState();
    // Get the Monday
    final now = getStartOfToday();
    fromDate = addLogicalDays(now, -(now.weekday - 1));
    setDate(fromDate);
  }

  @override
  Widget build(BuildContext context) {
    DateTime toDate = addLogicalDays(fromDate, 7);

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                    '${fromDate.day}${getDaySuffix(fromDate.day)} ${getMonthName(fromDate.month)} - ${toDate.day}${getDaySuffix(toDate.day)} ${getMonthName(toDate.month)}'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientButton(
                    onPressed: () => changeWeek(-1),
                    borderRadius: 100,
                    child: const Icon(Icons.chevron_left, size: 35),
                  ),
                  GradientButton(
                    onPressed: handleJumpToDate,
                    padding: 15,
                    child: const Text('Jump to Week'),
                  ),
                  GradientButton(
                    onPressed: () => changeWeek(1),
                    borderRadius: 100,
                    child: const Icon(Icons.chevron_right, size: 35),
                  ),
                ],
              ),
              if (errorMessage != null) ...[
                ErrorMessage(message: errorMessage!)
              ] else if (loading) ...[
                const Loading(),
              ] else if (timetableEntries.values
                  .every((entries) => entries.isEmpty)) ...[
                const Spacer(),
                Flexible(
                  flex: 4,
                  child: Column(
                    children: const [
                      Text('Nothing scheduled this week.'),
                      Text('Take it easy!'),
                      UndrawImage('relaxing_at_home'),
                    ],
                  ),
                )
              ] else
                for (int i = 0; i < 5; i++)
                  TimetableDay(
                    date: addLogicalDays(fromDate, i),
                    timetableEntries: timetableEntries[
                            getDateString(addLogicalDays(fromDate, i))] ??
                        [],
                  )
            ],
          ),
        ),
      ],
    );
  }
}
