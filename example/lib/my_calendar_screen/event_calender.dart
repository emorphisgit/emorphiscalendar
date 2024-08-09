// Copyright (c) 2024. Chetan Kailodia.
// Organization: Emorphis Technology

import 'package:emorphiscalendar/calendar/emorphis_event_calendar.dart';
import 'package:flutter/material.dart';

class EventCalendarScreen extends StatefulWidget {
  @override
  _EventCalendarScreenState createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Map<DateTime, List<String>> _events = {};

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime minDate = DateTime(today.year - 1, today.month, today.day);
    DateTime maxDate = DateTime(today.year + 1, today.month, today.day);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emorphis Event'),
        backgroundColor: Colors.blue.withOpacity(0.5),
        actions: [
          _buildAddEventButton(),
        ],
      ),
      body: Column(
        children: [
          EmorphisEventCalendar(
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            events: _events,
            onDaySelected: (selectedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            onFocusedDayChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            maxDate: maxDate,
            minDate: minDate,
          ),
          if (_events[_selectedDay] != null) _buildEventList(),
        ],
      ),
    );
  }

  Future<String?> _addEventDialog() {
    TextEditingController _controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Event"),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Enter event details'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_controller.text);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEventList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _events[_selectedDay]?.length ?? 0,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(_events[_selectedDay]![index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddEventButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          String? event = await _addEventDialog();
          if (event != null && event.isNotEmpty) {
            final updatedEvents = Map<DateTime, List<String>>.from(_events);
            updatedEvents[_selectedDay] = updatedEvents[_selectedDay] ?? [];
            updatedEvents[_selectedDay]!.add(event);
            setState(() {
              _events = updatedEvents;
            });
          }
        },
        child: const Text("Add Event"),
      ),
    );
  }
}
