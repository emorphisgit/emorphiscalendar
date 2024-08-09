// Copyright (c) 2024. Chetan Kailodia.
// Organization: Emorphis Technology
//

import 'dart:convert';

import 'package:emorphiscalendar/calendar/emorphis_holiday_calendar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'country.dart';

class HolidayCalendarScreen extends StatefulWidget {
  @override
  State<HolidayCalendarScreen> createState() => _HolidayCalendarScreenState();
}

class _HolidayCalendarScreenState extends State<HolidayCalendarScreen> {
  List<Holiday> holidays = [];
  DateTime _focusedDay = DateTime.now();
  String _selectedCountryCode = 'US'; // Default country code

  final List<DropdownMenuItem<String>> dropdownItems =
      countryList.map((Country country) {
    return DropdownMenuItem<String>(
      value: country.code,
      child: Text(country.name),
    );
  }).toList();

  Future<List<Holiday>> fetchHolidays(String countryCode, int year) async {
    final response = await http.get(
      Uri.parse(
          'https://date.nager.at/Api/v2/PublicHolidays/$year/$countryCode'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((holiday) {
        return Holiday(
          DateTime.parse(holiday['date']),
          holiday['name'],
        );
      }).toList();
    } else {
      setState(() {
        _focusedDay = _focusedDay;
        holidays = [];
      });
      throw Exception('Failed to load holidays');
    }
  }

  void _updateHolidays(DateTime newFocusedDay) {
    final newYear = newFocusedDay.year;
    fetchHolidays(_selectedCountryCode, newYear).then(
      (value) {
        holidays = [];
        setState(() {
          holidays = value;
          _focusedDay = newFocusedDay;
        });
      },
    );
  }

  void _onCountryCodeChanged(String? newCountryCode) {
    if (newCountryCode != null) {
      setState(() {
        _selectedCountryCode = newCountryCode;
        _updateHolidays(_focusedDay);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch holidays for the current year
    _updateHolidays(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holiday Calendar'),
        backgroundColor: Colors.blue.withOpacity(0.5),
        actions: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 150, // Adjust the width as needed
              child: DropdownButton<String>(
                value: _selectedCountryCode,
                onChanged: _onCountryCodeChanged,
                items: dropdownItems,
                isExpanded:
                    true, // Ensures the dropdown fills the width of the SizedBox
                autofocus: true,
              ),
            ),
          ),
        ],
      ),
      body: EmorphisHolidayCalendar(
        holidays: holidays,
        initialFocusedDay: _focusedDay,
        initialSelectedDay: DateTime.now(),
        onFocusedDayChanged: _updateHolidays,
      ),
    );
  }
}
