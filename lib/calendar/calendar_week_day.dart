// Copyright (c) 2024. Chetan Kailodia.
// Organization: Emorphis Technology

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A widget that displays the days of the week header
/// based on the provided locale.
///
/// The header is displayed as a row with each day of the week
/// (e.g., Sun, Mon, etc.) aligned center. The day names are generated
/// based on the locale specified.
///
/// Example usage:
/// ```dart
/// CalenderWeekDayHeader(locale: "en_US");
/// ```
///
/// [locale] is the locale code to be used for day names.
class CalenderWeekDayHeader extends StatelessWidget {
  /// The locale code for generating day names.
  final String locale;

  /// Creates a [CalenderWeekDayHeader] widget.
  ///
  /// The [locale] parameter must not be null.
  CalenderWeekDayHeader({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return _buildDaysOfWeek();
  }

  /// Builds a row of abbreviated day names based on the locale.
  ///
  /// The day names are generated starting from Sunday (assuming locale
  /// starts the week on Sunday). The row is evenly spaced with each
  /// day name centered.
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
