// Copyright (c) 2024. Chetan Kailodia.
// Organization: Emorphis Technology

import 'package:flutter/material.dart';

/// A custom widget that displays a horizontal scrolling list of dates for the entire year.
///
/// The selected date is highlighted, and a callback is triggered when a date is selected.
///
/// [initialSelectedDate] is the date that should be selected initially when the widget is loaded.
/// [onDateSelected] is a callback that returns the selected date when the user selects a date from the list.
class CustomWeekDay extends StatefulWidget {
  final DateTime? initialSelectedDate;
  final void Function(DateTime)? onDateSelected;

  const CustomWeekDay({
    super.key,
    this.initialSelectedDate,
    this.onDateSelected,
  });

  @override
  _CustomWeekDayState createState() => _CustomWeekDayState();
}

class _CustomWeekDayState extends State<CustomWeekDay> {
  late DateTime selectedDate; // The currently selected date
  late int
      currentDateSelectedIndex; // The index of the currently selected date in the list
  final ScrollController scrollController =
      ScrollController(); // Controller to track the scroll position of the ListView

  // List of month abbreviations
  List<String> listOfMonths = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  // List of day abbreviations
  List<String> listOfDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  @override
  void initState() {
    super.initState();
    // Set the selected date to either the initial selected date or the current date
    selectedDate = widget.initialSelectedDate ?? DateTime.now();
    // Calculate the index of the selected date relative to the current date
    currentDateSelectedIndex = DateTime.now().difference(selectedDate).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display the selected date in a specific format
        Container(
          height: 30,
          margin: const EdgeInsets.only(left: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            "${selectedDate.day}-${listOfMonths[selectedDate.month - 1]}, ${selectedDate.year}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.indigo[700],
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Display the horizontal scrolling list of dates
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SizedBox(
            height: 90,
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 10);
              },
              itemCount: 365, // Number of days to display (one year)
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                DateTime date = DateTime.now().add(Duration(
                    days: index)); // Calculate the date based on the index
                bool isSelected = currentDateSelectedIndex ==
                    index; // Check if the current index is the selected one

                return InkWell(
                  onTap: () {
                    setState(() {
                      currentDateSelectedIndex = index;
                      selectedDate = date;
                    });
                    // Trigger the callback when a date is selected
                    if (widget.onDateSelected != null) {
                      widget.onDateSelected!(date);
                    }
                  },
                  child: Container(
                    height: 80,
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          offset: const Offset(3, 3),
                          blurRadius: 5,
                        ),
                      ],
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Display month abbreviation
                        Text(
                          listOfMonths[date.month - 1],
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 1),
                        // Display day of the month
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 0),
                        // Display day of the week
                        Text(
                          listOfDays[date.weekday - 1],
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
