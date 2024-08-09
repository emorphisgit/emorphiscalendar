// Copyright (c) 2024. Chetan Kailodia.
// Organization: Emorphis Technology

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A model class representing a holiday with a [date] and a [name].
class Holiday {
  final DateTime date;
  final String name;

  Holiday(this.date, this.name);
}

/// A customizable holiday calendar widget that displays a month view with days
/// arranged in a grid, highlighting holidays and allowing for day selection.
///
/// The calendar also provides a list of holidays for the selected day.
class EmorphisHolidayCalendar extends StatefulWidget {
  /// A list of holidays to be displayed on the calendar.
  final List<Holiday> holidays;

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

  /// The locale string used to format the days of the week and month names.
  final String localeString;

  /// Callback function that is triggered when the focused day is changed.
  /// The new focused [DateTime] object is passed as a parameter.
  final ValueChanged<DateTime> onFocusedDayChanged;

  /// Creates an instance of [EmorphisHolidayCalendar].
  ///
  /// All parameters are optional except for the list of holidays and the
  /// [onFocusedDayChanged] callback.
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

  /// Returns a list of [DateTime] objects representing all the days in the
  /// month of the given [date].
  List<DateTime> _daysInMonth(DateTime date) {
    DateTime lastOfMonth = DateTime(date.year, date.month + 1, 0);

    return List.generate(
      lastOfMonth.day,
      (index) => DateTime(date.year, date.month, index + 1),
    );
  }

  /// Updates the list of holidays for the currently selected day.
  void _updateSelectedDayHolidays() {
    _selectedDayHolidays = widget.holidays
        .where((holiday) => _isSameDay(holiday.date, _selectedDay))
        .toList();
  }

  /// Checks if two [DateTime] objects represent the same calendar day.
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

  /// Builds the grid of day widgets representing the current month.
  ///
  /// Each day widget is a tappable container that highlights the selected day,
  /// today, Sundays, and holidays with the appropriate colors. Empty cells are added
  /// to align the first day of the month with its corresponding weekday.
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

  /// Builds a list of holidays for the currently selected day.
  ///
  /// If no holidays are found, a message indicating this is displayed.
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

/// A widget that displays the headers for the days of the week, customized by locale.
class CalendarWeekDayHolidayHeader extends StatelessWidget {
  /// The locale string used to format the day names.
  final String locale;

  /// Creates an instance of [CalendarWeekDayHolidayHeader].
  ///
  /// The [locale] parameter is required to ensure proper localization.
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
