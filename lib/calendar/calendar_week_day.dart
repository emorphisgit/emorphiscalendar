// Copyright (c) 2024. Chetan Kailodia.
// Organization: Emorphis Technology

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalenderWeekDayHeader extends StatelessWidget {
  final String locale;

  CalenderWeekDayHeader({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildDaysOfWeek();
  }

  Widget _buildDaysOfWeek() {
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
