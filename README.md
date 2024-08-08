# Emorphis Calendar


## Description

This Flutter package provides a customizable calendar with both monthly and weekly views, allowing users to easily navigate and select dates. The package also includes an event calendar widget for Flutter with support for dynamic events, date range restrictions, and event dot colors.


Make sure to check out [examples](https://github.com/emorphisgit/emorphiscalendar/tree/main/example) for more details.


## Features

* Monthly Calendar View: Displays a full month with selectable dates. Highlights the current date and marks Sundays in red.
* Weekly Calendar View: Shows a week at a time with swipe navigation between weeks.
* Event List: Displays a list of events for the selected day, with each event item bordered and padded for clarity.


## Installation

Add this package to your project by including it in your pubspec.yaml file:

```
dependencies:
  flutter:
    sdk: flutter
  emorphiscalendar: ^0.0.1
```

Then, run:

```
flutter pub get
```

## Usage

# Monthly Calendar

Make sure to check out [examples](https://github.com/emorphisgit/emorphiscalendar/tree/main/example) for more details.

```
import 'package:emorphiscalendar/calendar/emorphis_month_calendar.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Monthly Calendar')),
        body: EmorphisMonthCalendar(),
      ),
    );
  }
}
```

# Weekly Calendar

Make sure to check out [examples](https://github.com/emorphisgit/emorphiscalendar/tree/main/example) for more details.

```
import 'package:emorphiscalendar/calendar/emorphis_week_calendar.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Weekly Calendar')),
        body: EmorphisWeekCalendar(),
      ),
    );
  }
}
```

# Event List

The event list is automatically shown when you select a date with events in either the monthly or weekly calendar views. Customize the event list by modifying the _buildEventList method in the emorphis_calendar.dart file.

Make sure to check out [examples](https://github.com/emorphisgit/emorphiscalendar/tree/main/example) for more details.

```
import 'package:emorphiscalendar/calendar/emorphis_event_calendar.dart';


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
        title: const Text('Emorphis Event Calendar'),
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
```

# Holiday Calendar

Make sure to check out [examples](https://github.com/emorphisgit/emorphiscalendar/tree/main/example) for more details.


```
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

```

## Country Model

Make sure to check out [examples](https://github.com/emorphisgit/emorphiscalendar/tree/main/example) for more details.

```
class Country {
  final String code;
  final String name;

  Country(this.code, this.name);
}

final List<Country> countryList = [
  Country('AF', 'Afghanistan'),
  Country('AL', 'Albania'),
  Country('DZ', 'Algeria'),
  Country('AD', 'Andorra'),
  Country('AO', 'Angola'),
  Country('AG', 'Antigua and Barbuda'),
  Country('AR', 'Argentina'),
  Country('AM', 'Armenia'),
  Country('AU', 'Australia'),
  Country('AT', 'Austria'),
  Country('AZ', 'Azerbaijan'),
  Country('BS', 'Bahamas'),
  Country('BH', 'Bahrain'),
  Country('BD', 'Bangladesh'),
  Country('BB', 'Barbados'),
  Country('BY', 'Belarus'),
  Country('BE', 'Belgium'),
  Country('BZ', 'Belize'),
  Country('BJ', 'Benin'),
  Country('BT', 'Bhutan'),
  Country('BO', 'Bolivia'),
  Country('BA', 'Bosnia and Herzegovina'),
  Country('BW', 'Botswana'),
  Country('BR', 'Brazil'),
  Country('BN', 'Brunei'),
  Country('BG', 'Bulgaria'),
  Country('BF', 'Burkina Faso'),
  Country('BI', 'Burundi'),
  Country('CV', 'Cabo Verde'),
  Country('KH', 'Cambodia'),
  Country('CM', 'Cameroon'),
  Country('CA', 'Canada'),
  Country('CF', 'Central African Republic'),
  Country('TD', 'Chad'),
  Country('CL', 'Chile'),
  Country('CN', 'China'),
  Country('CO', 'Colombia'),
  Country('KM', 'Comoros'),
  Country('CG', 'Congo (Congo-Brazzaville)'),
  Country('CR', 'Costa Rica'),
  Country('HR', 'Croatia'),
  Country('CU', 'Cuba'),
  Country('CY', 'Cyprus'),
  Country('CZ', 'Czech Republic'),
  Country('DK', 'Denmark'),
  Country('DJ', 'Djibouti'),
  Country('DM', 'Dominica'),
  Country('DO', 'Dominican Republic'),
  Country('TL', 'East Timor'),
  Country('EC', 'Ecuador'),
  Country('EG', 'Egypt'),
  Country('SV', 'El Salvador'),
  Country('GQ', 'Equatorial Guinea'),
  Country('ER', 'Eritrea'),
  Country('EE', 'Estonia'),
  Country('SZ', 'Eswatini'),
  Country('ET', 'Ethiopia'),
  Country('FJ', 'Fiji'),
  Country('FI', 'Finland'),
  Country('FR', 'France'),
  Country('GA', 'Gabon'),
  Country('GM', 'Gambia'),
  Country('GE', 'Georgia'),
  Country('DE', 'Germany'),
  Country('GH', 'Ghana'),
  Country('GR', 'Greece'),
  Country('GD', 'Grenada'),
  Country('GT', 'Guatemala'),
  Country('GN', 'Guinea'),
  Country('GW', 'Guinea-Bissau'),
  Country('GY', 'Guyana'),
  Country('HT', 'Haiti'),
  Country('HN', 'Honduras'),
  Country('HU', 'Hungary'),
  Country('IS', 'Iceland'),
  Country('IN', 'India'),
  Country('ID', 'Indonesia'),
  Country('IR', 'Iran'),
  Country('IQ', 'Iraq'),
  Country('IE', 'Ireland'),
  Country('IL', 'Israel'),
  Country('IT', 'Italy'),
  Country('JM', 'Jamaica'),
  Country('JP', 'Japan'),
  Country('JO', 'Jordan'),
  Country('KZ', 'Kazakhstan'),
  Country('KE', 'Kenya'),
  Country('KI', 'Kiribati'),
  Country('KP', 'Korea, North'),
  Country('KR', 'Korea, South'),
  Country('XK', 'Kosovo'),
  Country('KW', 'Kuwait'),
  Country('KG', 'Kyrgyzstan'),
  Country('LA', 'Laos'),
  Country('LV', 'Latvia'),
  Country('LB', 'Lebanon'),
  Country('LS', 'Lesotho'),
  Country('LR', 'Liberia'),
  Country('LY', 'Libya'),
  Country('LI', 'Liechtenstein'),
  Country('LT', 'Lithuania'),
  Country('LU', 'Luxembourg'),
  Country('MG', 'Madagascar'),
  Country('MW', 'Malawi'),
  Country('MY', 'Malaysia'),
  Country('MV', 'Maldives'),
  Country('ML', 'Mali'),
  Country('MT', 'Malta'),
  Country('MH', 'Marshall Islands'),
  Country('MR', 'Mauritania'),
  Country('MU', 'Mauritius'),
  Country('MX', 'Mexico'),
  Country('FM', 'Micronesia'),
  Country('MD', 'Moldova'),
  Country('MC', 'Monaco'),
  Country('MN', 'Mongolia'),
  Country('ME', 'Montenegro'),
  Country('MA', 'Morocco'),
  Country('MZ', 'Mozambique'),
  Country('MM', 'Myanmar'),
  Country('NA', 'Namibia'),
  Country('NR', 'Nauru'),
  Country('NP', 'Nepal'),
  Country('NL', 'Netherlands'),
  Country('NZ', 'New Zealand'),
  Country('NI', 'Nicaragua'),
  Country('NE', 'Niger'),
  Country('NG', 'Nigeria'),
  Country('MK', 'North Macedonia'),
  Country('NO', 'Norway'),
  Country('OM', 'Oman'),
  Country('PK', 'Pakistan'),
  Country('PW', 'Palau'),
  Country('PA', 'Panama'),
  Country('PG', 'Papua New Guinea'),
  Country('PY', 'Paraguay'),
  Country('PE', 'Peru'),
  Country('PH', 'Philippines'),
  Country('PL', 'Poland'),
  Country('PT', 'Portugal'),
  Country('QA', 'Qatar'),
  Country('RO', 'Romania'),
  Country('RU', 'Russia'),
  Country('RW', 'Rwanda'),
  Country('KN', 'Saint Kitts and Nevis'),
  Country('LC', 'Saint Lucia'),
  Country('VC', 'Saint Vincent and the Grenadines'),
  Country('WS', 'Samoa'),
  Country('SM', 'San Marino'),
  Country('ST', 'Sao Tome and Principe'),
  Country('SA', 'Saudi Arabia'),
  Country('SN', 'Senegal'),
  Country('RS', 'Serbia'),
  Country('SC', 'Seychelles'),
  Country('SL', 'Sierra Leone'),
  Country('SG', 'Singapore'),
  Country('SK', 'Slovakia'),
  Country('SI', 'Slovenia'),
  Country('SB', 'Solomon Islands'),
  Country('SO', 'Somalia'),
  Country('ZA', 'South Africa'),
  Country('SS', 'South Sudan'),
  Country('ES', 'Spain'),
  Country('LK', 'Sri Lanka'),
  Country('SD', 'Sudan'),
  Country('SR', 'Suriname'),
  Country('SE', 'Sweden'),
  Country('CH', 'Switzerland'),
  Country('SY', 'Syria'),
  Country('TW', 'Taiwan'),
  Country('TJ', 'Tajikistan'),
  Country('TZ', 'Tanzania'),
  Country('TH', 'Thailand'),
  Country('TG', 'Togo'),
  Country('TO', 'Tonga'),
  Country('TT', 'Trinidad and Tobago'),
  Country('TN', 'Tunisia'),
  Country('TR', 'Turkey'),
  Country('TM', 'Turkmenistan'),
  Country('TV', 'Tuvalu'),
  Country('UG', 'Uganda'),
  Country('UA', 'Ukraine'),
  Country('AE', 'United Arab Emirates'),
  Country('GB', 'United Kingdom'),
  Country('US', 'United States'),
  Country('UY', 'Uruguay'),
  Country('UZ', 'Uzbekistan'),
  Country('VU', 'Vanuatu'),
  Country('VA', 'Vatican City'),
  Country('VE', 'Venezuela'),
  Country('VN', 'Vietnam'),
  Country('YE', 'Yemen'),
  Country('ZM', 'Zambia'),
  Country('ZW', 'Zimbabwe'),
];

```


## API

### EmorphisEventCalendar<T>

Make sure to check out [examples](https://github.com/emorphisgit/emorphiscalendar/tree/main/example) for more details.


* focusedDay:  The currently focused day in the calendar.
* selectedDay: The currently selected day in the calendar.
* events: A map of events where the key is a DateTime and the value is a list of events.
* onDaySelected: Callback triggered when a day is selected.
* onFocusedDayChanged: Callback triggered when the focused day is changed.
* eventDotColor: Color of the event dot (default is red).
* minDate: Optional minimum date for the calendar.
* maxDate: Optional maximum date for the calendar.
* CalenderWeekDayHeader: It's use for the change week day according locale.

## License

This package is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.


## Links

* [GitHub Repository](https://github.com/emorphisgit/emorphiscalendar.git)
* [Documentation](https://pub.dev/packages/emorphiscalendar)



## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue to discuss what you would like to change.