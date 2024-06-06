import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_attendance_app/user/model/record_absen.dart';
class EventsList extends StatelessWidget {
  final List<RecordAbsen> events;
  const EventsList({super.key, required this.events});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow:[
          BoxShadow(
            color: Colors.black,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          Color eventColor;

          // Determine the color based on the event status
          switch (events[index].namaKeterangan.toUpperCase()) {
            case 'ALPHA':
              eventColor = Colors.red;
              break;
            case 'HADIR':
              eventColor = Colors.green;
              break;
            case 'IZIN':
              eventColor = Colors.yellow;
              break;
            default:
              eventColor = Colors.grey;
          }

          final timeFormat = DateFormat('HH:mm');
          final formattedTime = timeFormat.format(events[index].record);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                events[index].namaKeterangan,
                style: TextStyle(color: eventColor),
              ),
              subtitle: Text(formattedTime),
            ),
          );
        },
      ),
    );
  }
}
