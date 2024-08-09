// Copyright (c) 2024. Chetan Kailodia.
// Organization: Emorphis Technology

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'calendar_week_day.dart';

/// A customizable event calendar widget that displays events
/// on specific dates within a month. The widget allows navigation
/// between months and supports selecting days.
///
/// [T] is the type of event data associated with a specific date.
class EmorphisEventCalendar<T> extends StatefulWidget {
  /// The currently focused day in the calendar, typically the
  /// first day of the month being displayed.
  final DateTime focusedDay;

  /// The currently selected day in the calendar.
  final DateTime selectedDay;

  /// A map of dates to lists of events occurring on those dates.
  final Map<DateTime, List<T>> events;

  /// Callback when a day is selected.
  final ValueChanged<DateTime> onDaySelected;

  /// Callback when the focused day changes, usually due to
  /// navigation between months.
  final ValueChanged<DateTime> onFocusedDayChanged;

  /// The color of the dot indicating an event on a specific day.
  final Color eventDotColor;

  /// Optional parameter to specify the minimum date selectable in the calendar.
  final DateTime? minDate;

  /// Optional parameter to specify the maximum date selectable in the calendar.
  final DateTime? maxDate;

  /// Creates an [EmorphisEventCalendar] widget.
  ///
  /// The [focusedDay], [selectedDay], [events], [onDaySelected], and
  /// [onFocusedDayChanged] parameters are required.
  const EmorphisEventCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.events,
    required this.onDaySelected,
    required this.onFocusedDayChanged,
    this.eventDotColor = Colors.red,
    this.minDate,
    this.maxDate,
  });

  @override
  _EmorphisEventCalendarState<T> createState() =>
      _EmorphisEventCalendarState<T>();
}

class _EmorphisEventCalendarState<T> extends State<EmorphisEventCalendar<T>> {
  /// Generates a list of all the days in the given month.
  List<DateTime> _daysInMonth(DateTime date) {
    DateTime lastOfMonth = DateTime(date.year, date.month + 1, 0);

    return List.generate(
      lastOfMonth.day,
      (index) => DateTime(date.year, date.month, index + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> days = _daysInMonth(widget.focusedDay);

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

  /// Builds the header row containing the month and year,
  /// along with navigation arrows.
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            DateTime newMonth =
                DateTime(widget.focusedDay.year, widget.focusedDay.month - 1);
            if (widget.minDate == null || newMonth.isAfter(widget.minDate!)) {
              widget.onFocusedDayChanged(newMonth);
            }
          },
        ),
        Text(
          DateFormat.yMMMM().format(widget.focusedDay),
          style: const TextStyle(fontSize: 20.0),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            DateTime newMonth =
                DateTime(widget.focusedDay.year, widget.focusedDay.month + 1);
            if (widget.maxDate == null || newMonth.isBefore(widget.maxDate!)) {
              widget.onFocusedDayChanged(newMonth);
            }
          },
        ),
      ],
    );
  }

  /// Builds the grid of days in the currently focused month.
  ///
  /// Days outside the selectable date range are shown in grey.
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
          return const SizedBox.shrink(); // Empty cell before first day
        }
        DateTime day = days[index - leadingEmptyCells];
        bool isSelected = day == widget.selectedDay;
        bool isToday = day == DateTime.now();
        bool isSunday = day.weekday == DateTime.sunday;
        bool isWithinBounds = (widget.minDate == null ||
                day.isAfter(widget.minDate!.subtract(Duration(days: 1)))) &&
            (widget.maxDate == null ||
                day.isBefore(widget.maxDate!.add(Duration(days: 1))));

        return GestureDetector(
          onTap: () {
            if (isWithinBounds) {
              widget.onDaySelected(day);
            }
          },
          child: Container(
            alignment: Alignment.center,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue
                    : isToday
                        ? Colors.blue.withOpacity(0.5)
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
                                    ? Colors.red
                                    : isWithinBounds
                                        ? Colors.black
                                        : Colors.grey,
                      ),
                    ),
                  ),
                  if (widget.events[day] != null &&
                      widget.events[day]!.isNotEmpty)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: widget.eventDotColor,
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
}
