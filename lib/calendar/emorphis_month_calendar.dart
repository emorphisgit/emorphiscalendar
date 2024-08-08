// Copyright (c) 2024. Chetan Kailodia.
// Organization: Emorphis Technology
//

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'calendar_week_day.dart';

class EmorphisMonthCalendar extends StatefulWidget {
  final DateTime? initialFocusedDay;
  final DateTime? initialSelectedDay;
  final Color selectedDayColor;
  final Color todayColor;
  final Color sundayTextColor;
  final void Function(DateTime)? onDaySelected;

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
          style: TextStyle(fontSize: 20.0),
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

  Widget _buildDaysGrid(List<DateTime> days) {
    int firstWeekday = days.first.weekday;
    int leadingEmptyCells = firstWeekday % 7;

    return GridView.builder(
      shrinkWrap: true,
      itemCount: days.length + leadingEmptyCells,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemBuilder: (context, index) {
        if (index < leadingEmptyCells) {
          return SizedBox.shrink(); // Empty cell before first day
        }
        DateTime day = days[index - leadingEmptyCells];
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
            });
            if (widget.onDaySelected != null) {
              widget.onDaySelected!(day);
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
                              ? widget.sundayTextColor
                              : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
