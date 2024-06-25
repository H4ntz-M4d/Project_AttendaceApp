// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_attendance_app/api_connection/api_connection.dart';
import 'package:project_attendance_app/user/model/event_list.dart';
import 'package:project_attendance_app/user/model/guru.dart';
import 'package:project_attendance_app/user/model/record_absen.dart';
import 'package:project_attendance_app/user/model/siswa.dart';
import 'package:project_attendance_app/user/userPreferences/current_user.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

import 'utils.dart';

class TableEventsExample extends StatefulWidget {
  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<RecordAbsen>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  final CurrentUser _currentUser = Get.put(CurrentUser());
  Map<DateTime, List<RecordAbsen>> event = {};

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<RecordAbsen> _getEventsForDay(DateTime day) {
    // Implementation example
    DateTime dateWithoutTime = DateTime(day.year, day.month, day.day);
    return event[dateWithoutTime] ?? [];
  }

  List<RecordAbsen> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  Future<void> _fetchEventsForMonth(int year, int month) async {
    String id = '';
    String role = '';

    if (_currentUser.user is Guru) {
      id = (_currentUser.user as Guru).nip;
      role = (_currentUser.user as Guru).role;
    } else if (_currentUser.user is Siswa) {
      id = (_currentUser.user as Siswa).nis;
      role = (_currentUser.user as Siswa).role;
    }
    try {
      final response = await http.post(Uri.parse(API.getMonthRecords), body: {
        "nis": id,
        "year": year.toString(),
        "month": month.toString().padLeft(2, '0'),
        "role": role
      });
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          if (data['success']) {
            setState(() {
              event.clear();
              for (var eventJson in data['events']) {
                RecordAbsen recordAbsen = RecordAbsen.fromJson(eventJson);
                DateTime eventDate =
                    DateTime.parse(eventJson['kalender_absensi']);
                DateTime dateWithoutTime =
                    DateTime(eventDate.year, eventDate.month, eventDate.day);

                if (event[dateWithoutTime] == null) {
                  event[dateWithoutTime] = [];
                }
                event[dateWithoutTime]?.add(recordAbsen);
              }
              _selectedEvents.value = _getEventsForDay(_selectedDay!);
            });
          }
        } catch (e) {
          print("Error parsing JSON: $e");
        }
      }
    } catch (e) {}
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
    _fetchEventsForMonth(focusedDay.year, focusedDay.month);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Absensi'),
      ),
      body: Column(
        children: [
          TableCalendar<RecordAbsen>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: _onPageChanged,
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<RecordAbsen>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return EventsList(events: value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
