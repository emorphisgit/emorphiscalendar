// Copyright (c) 2024. Chetan Kailodia.
// Organization: Emorphis Technology
//
//

import 'package:emorphiscalendar/calendar/emorphis_week_calendar.dart';
import 'package:flutter/material.dart';

class WeekCalendarScreen extends StatelessWidget {
  const WeekCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Week Calender'),
        backgroundColor: Colors.blue.withOpacity(0.5),
      ),
      body: Center(
        child: EmorphisWeeklyCalendar(
          initialFocusedDay: DateTime.now(),
          initialSelectedDay: DateTime.now(),
          onDaySelected: (date) {
            print("Selected date: $date");
          },
        ),
      ),
    );
  }
}
