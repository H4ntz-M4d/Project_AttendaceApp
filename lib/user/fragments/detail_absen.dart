import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_attendance_app/api_connection/api_connection.dart';
import 'package:project_attendance_app/user/model/record_absen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class DetailAbsen extends StatefulWidget {
  const DetailAbsen({super.key});

  @override
  State<DetailAbsen> createState() => _DetailAbsenState();
}

class _DetailAbsenState extends State<DetailAbsen> {
  DateTime today = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<RecordAbsen>> event = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final String nis =
        '001'; // NIS yang ingin diambil, sesuaikan dengan kebutuhan Anda.
    final response = await http.get(Uri.parse(API.getRecord));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          for (var event in data['events']) {
            DateTime eventDate = DateTime.parse(event['record']);
            if (this.event[eventDate] == null) {
              this.event[eventDate] = [];
            }
            this.event[eventDate]?.add(RecordAbsen.fromJson(event));
          }
        });
      }
    } else {
      // Handle error
    }
  }

  List<RecordAbsen> _getEventsForDay(DateTime day) {
    return event[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Detail Absen',
          style: GoogleFonts.lato(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text('Selected Day = ' + (today.toString().split(" ")[0])),
              Container(
                child: TableCalendar(
                  locale: "en_US",
                  rowHeight: 43,
                  headerStyle: const HeaderStyle(
                      formatButtonVisible: false, titleCentered: true),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  firstDay: DateTime.utc(2018, 01, 01),
                  lastDay: DateTime.utc(2045, 12, 30),
                  onDaySelected: _onDaySelected,
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                  ),
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  eventLoader: _getEventsForDay,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ..._getEventsForDay(_selectedDay!)
                  .map((RecordAbsen event) => ListTile(
                        title: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(event.kodeKeterangan)),
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
