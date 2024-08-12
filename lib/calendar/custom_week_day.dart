// Copyright (c) 2024. Chetan Kailodia.
// Organization: Emorphis Technology

import 'package:flutter/material.dart';

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
  late DateTime selectedDate;
  late int currentDateSelectedIndex;
  final ScrollController scrollController = ScrollController();

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

  List<String> listOfDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialSelectedDate ?? DateTime.now();
    currentDateSelectedIndex = DateTime.now().difference(selectedDate).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display selected date
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
        // Calendar widget
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SizedBox(
            height: 90,
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: 10);
              },
              itemCount: 365,
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                DateTime date = DateTime.now().add(Duration(days: index));
                bool isSelected = currentDateSelectedIndex == index;

                return InkWell(
                  onTap: () {
                    setState(() {
                      currentDateSelectedIndex = index;
                      selectedDate = date;
                    });
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
                          offset: Offset(3, 3),
                          blurRadius: 5,
                        ),
                      ],
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          listOfMonths[date.month - 1],
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 0),
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
