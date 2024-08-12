// Copyright (c) 2024. Chetan Kailodia.
// Organization: Emorphis Technology
//

import 'package:example/my_calendar_screen/custom_week.dart';
import 'package:example/my_calendar_screen/holiday_calendar.dart';
import 'package:flutter/material.dart';

import '../my_calendar_screen/event_calender.dart';
import '../my_calendar_screen/month_calender.dart';
import '../my_calendar_screen/week_calendar.dart';

class MyCalendarListView extends StatelessWidget {
  const MyCalendarListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar List View'),
        backgroundColor: Colors.blue.withOpacity(0.5),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: ListView(
          children: [
            MyCalendarListTile(
              title: 'Week',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WeekCalendarScreen()),
                );
              },
            ),
            const SizedBox(height: 10), // Space between the items
            MyCalendarListTile(
              title: 'Custom Week',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CustomWeekScreen()),
                );
              },
            ),
            const SizedBox(height: 10), // Space between the items
            MyCalendarListTile(
              title: 'Month',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const MonthCalendarScreen()),
                );
              },
            ),
            const SizedBox(height: 10), // Space between the items
            MyCalendarListTile(
              title: 'Event',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EventCalendarScreen()),
                );
              },
            ),
            const SizedBox(height: 10), // Space between the items
            MyCalendarListTile(
              title: 'Holiday',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HolidayCalendarScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyCalendarListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const MyCalendarListTile({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
