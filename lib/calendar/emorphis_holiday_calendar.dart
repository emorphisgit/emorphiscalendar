// Copyright (c) 2024. Chetan Kailodia.
// Organization: Emorphis Technology

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Holiday {
  final DateTime date;
  final String name;

  Holiday(this.date, this.name);
}

class EmorphisHolidayCalendar extends StatefulWidget {
  final List<Holiday> holidays;
  final DateTime? initialFocusedDay;
  final DateTime? initialSelectedDay;
  final Color selectedDayColor;
  final Color todayColor;
  final Color sundayTextColor;
  final String localeString;
  final ValueChanged<DateTime> onFocusedDayChanged;

  const EmorphisHolidayCalendar({
    super.key,
    required this.holidays,
    this.initialFocusedDay,
    this.initialSelectedDay,
    this.selectedDayColor = Colors.blue,
    this.todayColor = Colors.blue,
    this.sundayTextColor = Colors.red,
    this.localeString = "en_US",
    required this.onFocusedDayChanged,
  });

  @override
  _EmorphisHolidayCalendarState createState() =>
      _EmorphisHolidayCalendarState();
}

class _EmorphisHolidayCalendarState extends State<EmorphisHolidayCalendar> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  List<Holiday> _selectedDayHolidays = [];

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialFocusedDay ?? DateTime.now();
    _selectedDay = widget.initialSelectedDay ?? DateTime.now();
    _updateSelectedDayHolidays();
  }

  List<DateTime> _daysInMonth(DateTime date) {
    DateTime lastOfMonth = DateTime(date.year, date.month + 1, 0);

    return List.generate(
      lastOfMonth.day,
      (index) => DateTime(date.year, date.month, index + 1),
    );
  }

  void _updateSelectedDayHolidays() {
    _selectedDayHolidays = widget.holidays
        .where((holiday) => _isSameDay(holiday.date, _selectedDay))
        .toList();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> days = _daysInMonth(_focusedDay);

    return Column(
      children: [
        _buildHeader(),
        CalendarWeekDayHolidayHeader(locale: widget.localeString),
        _buildDaysGrid(days),
        _buildHolidayList(),
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
              widget.onFocusedDayChanged(_focusedDay);
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
              widget.onFocusedDayChanged(_focusedDay);
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemBuilder: (context, index) {
        if (index < leadingEmptyCells) {
          return SizedBox.shrink(); // Empty cell before first day
        }
        DateTime day = days[index - leadingEmptyCells];
        bool isSelected = _isSameDay(day, _selectedDay);
        bool isToday = _isSameDay(day, DateTime.now());
        bool isSunday = day.weekday == DateTime.sunday;
        bool hasHoliday =
            widget.holidays.any((holiday) => _isSameDay(holiday.date, day));

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = day;
              _updateSelectedDayHolidays();
            });
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
              child: Stack(
                children: [
                  Center(
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
                  if (hasHoliday)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        height: 8,
                        width: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHolidayList() {
    if (_selectedDayHolidays.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Text('No holidays on this day.'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _selectedDayHolidays.length,
      itemBuilder: (context, index) {
        Holiday holiday = _selectedDayHolidays[index];
        return ListTile(
          title: Text(holiday.name),
          subtitle: Text(DateFormat.yMMMMd().format(holiday.date)),
        );
      },
    );
  }
}

class CalendarWeekDayHolidayHeader extends StatelessWidget {
  final String locale;

  const CalendarWeekDayHolidayHeader({
    super.key,
    required this.locale, // Add locale parameter
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        // Generate the day name based on the locale
        String dayName =
            DateFormat.E(locale).format(DateTime(2021, 8, 1 + index));
        return Expanded(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              dayName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }),
    );
  }
}
