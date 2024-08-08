// Copyright (c) 2024. Chetan Kailodia.
// Organization: Emorphis Technology
//

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'calendar_week_day.dart';

class EmorphisWeeklyCalendar extends StatefulWidget {
  final DateTime initialFocusedDay;
  final DateTime initialSelectedDay;
  final Function(DateTime) onDaySelected;
  final Color selectedColor;
  final Color todayColor;
  final Color sundayColor;
  final Color defaultTextColor;

  const EmorphisWeeklyCalendar({
    Key? key,
    required this.initialFocusedDay,
    required this.initialSelectedDay,
    required this.onDaySelected,
    this.selectedColor = Colors.blue,
    this.todayColor = Colors.blue,
    this.sundayColor = Colors.red,
    this.defaultTextColor = Colors.black,
  }) : super(key: key);

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

  List<DateTime> _daysInWeek(DateTime date) {
    int daysFromSunday = date.weekday % 7;
    DateTime firstDayOfWeek = date.subtract(Duration(days: daysFromSunday));

    return List.generate(
      7,
      (index) => firstDayOfWeek.add(Duration(days: index)),
    );
  }

  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity == null) return;

    setState(() {
      if (details.primaryVelocity! < 0) {
        _focusedDay = _focusedDay.add(Duration(days: 7));
      } else if (details.primaryVelocity! > 0) {
        _focusedDay = _focusedDay.subtract(Duration(days: 7));
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _focusedDay = _focusedDay.subtract(Duration(days: 7));
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
              _focusedDay = _focusedDay.add(Duration(days: 7));
            });
          },
        ),
      ],
    );
  }

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
