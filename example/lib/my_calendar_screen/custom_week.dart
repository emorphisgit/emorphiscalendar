// Copyright (c) 2024. Chetan Kailodia.
// Organization: Emorphis Technology

import 'package:emorphiscalendar/calendar/custom_week_day.dart';
import 'package:flutter/material.dart';

class CustomWeekScreen extends StatelessWidget {
  const CustomWeekScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Week Day'),
        backgroundColor: Colors.blue.withOpacity(0.5),
      ),
      body: Center(
        child: CustomWeekDay(
          onDateSelected: (date) {
            print(date);
          },
        ),
      ),
    );
  }
}
