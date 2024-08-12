// Copyright (c) 2024. Chetan Kailodia.
// Organization: Emorphis Technology
//

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'calendar_week_day.dart';

/// A customizable monthly calendar widget that displays a month view with days
/// arranged in a grid. This widget allows for day selection and navigation
/// between months.
///
/// The calendar highlights the selected day, today, and Sundays with customizable colors.
class EmorphisMonthCalendar extends StatefulWidget {
  /// The initial day that is focused when the calendar is first created.
  final DateTime? initialFocusedDay;

  /// The initial day that is selected when the calendar is first created.
  final DateTime? initialSelectedDay;

  /// The color used to highlight the selected day.
  final Color selectedDayColor;

  /// The color used to highlight today.
  final Color todayColor;

  /// The color used for the text on Sundays.
  final Color sundayTextColor;

  /// Callback function that is triggered when a day is selected.
  /// The selected [DateTime] object is passed as a parameter.
  final void Function(DateTime)? onDaySelected;

  /// Creates an instance of [EmorphisMonthCalendar].
  ///
  /// All parameters are optional except for colors, which have default values.
  const EmorphisMonthCalendar({
    super.key,
    this.initialFocusedDay,
    this.initialSelectedDay,
    this.selectedDayColor = Colors.blue,
    this.todayColor = Colors.blue,
    this.sundayTextColor = Colors.red,
    this.onDaySelected,
  });

  @override
  _EmorphisMonthCalendarState createState() => _EmorphisMonthCalendarState();
}

class _EmorphisMonthCalendarState extends State<EmorphisMonthCalendar> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialFocusedDay ?? DateTime.now();
    _selectedDay = widget.initialSelectedDay ?? DateTime.now();
  }

  /// Returns a list of [DateTime] objects representing all the days in the
  /// month of the given [date].
  List<DateTime> _daysInMonth(DateTime date) {
    DateTime lastOfMonth = DateTime(date.year, date.month + 1, 0);

    return List.generate(
      lastOfMonth.day,
      (index) => DateTime(date.year, date.month, index + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> days = _daysInMonth(_focusedDay);

    return Column(
      children: [
        _buildHeader(),
        CalenderWeekDayHeader(
          locale: "en-US",
        ),
        _buildDaysGrid(days),
      ],
    );
  }

  /// Builds the header row with navigation arrows and the current month displayed.
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
            });
          },
        ),
        Text(
          DateFormat.yMMMM().format(_focusedDay),
          style: const TextStyle(fontSize: 20.0),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            setState(() {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
            });
          },
        ),
      ],
    );
  }

  /// Builds the grid of day widgets representing the current month.
  ///
  /// Each day widget is a tappable container that highlights the selected day,
  /// today, and Sundays with the appropriate colors. Empty cells are added
  /// to align the first day of the month with its corresponding weekday.
  Widget _buildDaysGrid(List<DateTime> days) {
    int firstWeekday = days.first.weekday;
    int leadingEmptyCells = firstWeekday % 7;
    int totalDaysInGrid = days.length + leadingEmptyCells;
    int trailingEmptyCells = 7 - (totalDaysInGrid % 7);

    // Previous month's last days
    List<DateTime> previousMonthDays = List.generate(
      leadingEmptyCells,
      (index) => DateTime(
        _focusedDay.year,
        _focusedDay.month,
        1 - (leadingEmptyCells - index),
      ),
    );

    // Next month's first days
    List<DateTime> nextMonthDays = List.generate(
      trailingEmptyCells,
      (index) => DateTime(
        _focusedDay.year,
        _focusedDay.month + 1,
        index + 1,
      ),
    );

    return GridView.builder(
      shrinkWrap: true,
      itemCount: days.length + leadingEmptyCells + trailingEmptyCells,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemBuilder: (context, index) {
        if (index < leadingEmptyCells) {
          DateTime day = previousMonthDays[index];
          return _buildDayContainer(day, isInCurrentMonth: false);
        } else if (index >= days.length + leadingEmptyCells) {
          DateTime day = nextMonthDays[index - days.length - leadingEmptyCells];
          return _buildDayContainer(day, isInCurrentMonth: false);
        } else {
          DateTime day = days[index - leadingEmptyCells];
          return _buildDayContainer(day, isInCurrentMonth: true);
        }
      },
    );
  }

  Widget _buildDayContainer(DateTime day, {required bool isInCurrentMonth}) {
    bool isSelected = day.day == _selectedDay.day &&
        day.month == _selectedDay.month &&
        day.year == _selectedDay.year;
    bool isToday = day.day == DateTime.now().day &&
        day.month == DateTime.now().month &&
        day.year == DateTime.now().year;
    bool isSunday = day.weekday == DateTime.sunday;

    return GestureDetector(
      onTap: () {
        if (isInCurrentMonth) {
          setState(() {
            _selectedDay = day;
          });
          if (widget.onDaySelected != null) {
            widget.onDaySelected!(day);
          }
        }
      },
      child: Container(
        alignment: Alignment.center,
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: isSelected
                ? widget.selectedDayColor
                : isToday
                    ? widget.todayColor.withOpacity(0.5)
                    : null,
            borderRadius: BorderRadius.circular(8.0),
          ),
          alignment: Alignment.center,
          child: Text(
            day.day.toString(),
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : isToday
                      ? Colors.white
                      : isSunday
                          ? !isInCurrentMonth
                              ? Colors.grey
                              : widget.sundayTextColor
                          : isInCurrentMonth
                              ? Colors.black
                              : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
