// Copyright (c) 2024. Chetan Kailodia.
// Organization: Emorphis Technology
//

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'calendar_week_day.dart';

/// A customizable weekly calendar widget that displays a week view and allows
/// for day selection. This widget is designed to be reusable and adaptable to
/// various use cases.
///
/// The calendar shows the days of the week, highlights the selected day, today,
/// and Sundays with customizable colors, and allows the user to navigate between
/// weeks with swipe gestures or arrow buttons.
class EmorphisWeeklyCalendar extends StatefulWidget {
  /// The initial day that is focused when the calendar is first created.
  final DateTime initialFocusedDay;

  /// The initial day that is selected when the calendar is first created.
  final DateTime initialSelectedDay;

  /// Callback function that is triggered when a day is selected.
  /// The selected [DateTime] object is passed as a parameter.
  final Function(DateTime) onDaySelected;

  /// The color used to highlight the selected day.
  final Color selectedColor;

  /// The color used to highlight today.
  final Color todayColor;

  /// The color used to highlight Sundays.
  final Color sundayColor;

  /// The default text color used for the day numbers.
  final Color defaultTextColor;

  /// Creates an instance of [EmorphisWeeklyCalendar].
  ///
  /// All parameters are required except for colors, which have default values.
  const EmorphisWeeklyCalendar({
    super.key,
    required this.initialFocusedDay,
    required this.initialSelectedDay,
    required this.onDaySelected,
    this.selectedColor = Colors.blue,
    this.todayColor = Colors.blue,
    this.sundayColor = Colors.red,
    this.defaultTextColor = Colors.black,
  });

  @override
  _EmorphisWeeklyCalendarState createState() => _EmorphisWeeklyCalendarState();
}

class _EmorphisWeeklyCalendarState extends State<EmorphisWeeklyCalendar> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialFocusedDay;
    _selectedDay = widget.initialSelectedDay;
  }

  /// Returns a list of [DateTime] objects representing the days in the week
  /// of the given [date]. The week starts from Sunday.
  List<DateTime> _daysInWeek(DateTime date) {
    int daysFromSunday = date.weekday % 7;
    DateTime firstDayOfWeek = date.subtract(Duration(days: daysFromSunday));

    return List.generate(
      7,
      (index) => firstDayOfWeek.add(Duration(days: index)),
    );
  }

  /// Handles horizontal swipe gestures to navigate between weeks.
  /// Swiping left moves to the next week, and swiping right moves to the previous week.
  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity == null) return;

    setState(() {
      if (details.primaryVelocity! < 0) {
        _focusedDay = _focusedDay.add(const Duration(days: 7));
      } else if (details.primaryVelocity! > 0) {
        _focusedDay = _focusedDay.subtract(const Duration(days: 7));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> days = _daysInWeek(_focusedDay);

    return GestureDetector(
      onHorizontalDragEnd: _onHorizontalDrag,
      child: Column(
        children: [
          _buildHeader(),
          CalenderWeekDayHeader(
            locale: "en-US",
          ),
          const SizedBox(height: 8),
          _buildDaysRow(days),
        ],
      ),
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
              _focusedDay = _focusedDay.subtract(const Duration(days: 7));
            });
          },
        ),
        Text(
          DateFormat.yMMMM().format(_focusedDay),
          style: TextStyle(fontSize: 20.0),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            setState(() {
              _focusedDay = _focusedDay.add(const Duration(days: 7));
            });
          },
        ),
      ],
    );
  }

  /// Builds the row of day widgets representing the current week.
  ///
  /// Each day widget is a tappable container that highlights the selected day,
  /// today, and Sundays with the appropriate colors.
  Widget _buildDaysRow(List<DateTime> days) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((day) {
        bool isSelected = day.day == _selectedDay.day &&
            day.month == _selectedDay.month &&
            day.year == _selectedDay.year;
        bool isToday = day.day == DateTime.now().day &&
            day.month == DateTime.now().month &&
            day.year == DateTime.now().year;
        bool isSunday = day.weekday == DateTime.sunday;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = day;
              widget.onDaySelected(_selectedDay);
            });
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: isSelected
                  ? widget.selectedColor
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
                            ? widget.sundayColor
                            : widget.defaultTextColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
