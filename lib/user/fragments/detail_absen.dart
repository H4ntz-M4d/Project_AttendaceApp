import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_attendance_app/api_connection/api_connection.dart';
import 'package:project_attendance_app/user/model/record_absen.dart';
import 'package:project_attendance_app/user/userPreferences/current_siswa.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:project_attendance_app/user/model/event_list.dart';
import 'package:http/http.dart' as http;

class DetailAbsen extends StatefulWidget {
  const DetailAbsen({Key? key}) : super(key: key);

  @override
  State<DetailAbsen> createState() => _DetailAbsenState();
}

class _DetailAbsenState extends State<DetailAbsen> {
  Map<DateTime, List<RecordAbsen>> event = {};
  List<RecordAbsen> _selectedEvents = [];
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final CurrentSiswa _currentUser = Get.put(CurrentSiswa());

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _currentUser.getUserInfo().then((_) {
      _fetchEvents();
    });
  }

  Future<void> _fetchEvents() async {
    final String nis = _currentUser.user.nis;
    final response =
        await http.post(Uri.parse(API.getRecord), body: {'nis': nis});
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
            _selectedEvents = _getEventsForDay(_selectedDay);
          });
        }
      } catch (e) {
        print("Error parsing JSON: $e");
      }
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents = _getEventsForDay(selectedDay);
      });
    }
  }

  List<RecordAbsen> _getEventsForDay(DateTime day) {
    DateTime dateWithoutTime = DateTime(day.year, day.month, day.day);
    final events = event[dateWithoutTime] ?? [];
    return events;
  }

  Widget _buildEventsMarker(DateTime date, List<dynamic> events) {
    if (events.isEmpty) return const SizedBox();

    // Display a single marker for dates with events
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Colors.blueGrey, // Choose a default color for the marker
        shape: BoxShape.circle,
      ),
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Detail Absen ",
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 30,
              color: Color.fromARGB(255, 247, 238, 221),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              backgroundColor: Colors.white,
              minimumSize: const Size(60, 60),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.zero,
                  topEnd: Radius.zero,
                  bottomStart: Radius.circular(20),
                ),
              ),
            ),
            child: const Center(
              child: Icon(Icons.arrow_back),
            ),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 0, 141, 218),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 141, 218),
      body: Center(
        child: Column(
          children: [
            // Calendar Control
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width *
                  0.8, // 80% of the screen width
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime(_focusedDay.year - 10),
                lastDay: DateTime(_focusedDay.year + 10),
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                onDaySelected: _onDaySelected,
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: _getEventsForDay,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  selectedDecoration: const BoxDecoration(
                    color: Color.fromARGB(255, 0, 141, 218),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: const BoxDecoration(
                    color: Color.fromARGB(255, 53, 114, 239),
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(color: Colors.white),
                  defaultTextStyle: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  todayTextStyle: const TextStyle(color: Colors.white),
                ),
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 25),
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    return _buildEventsMarker(date, events);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Event Control
            Expanded(
              child: EventsList(events: _selectedEvents),
            ),
          ],
        ),
      ),
    );
  }
}
