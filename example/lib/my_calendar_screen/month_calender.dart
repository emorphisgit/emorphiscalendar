// Copyright (c) 2024. Chetan Kailodia.
// Organization: Emorphis Technology

import 'package:emorphiscalendar/calendar/emorphis_month_calendar.dart';
import 'package:flutter/material.dart';

class MonthCalendarScreen extends StatelessWidget {
  const MonthCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Month Calender'),
        backgroundColor: Colors.blue.withOpacity(0.5),
      ),
      body: const Center(
        child: EmorphisMonthCalendar(),
      ),
    );
  }
}
