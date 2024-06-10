import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          var sizedBoxAttribute;
          var sizedBoxStatus;

          // Determine the color based on the event status
          switch (events[index].namaKeterangan.toUpperCase()) {
            case 'ALPHA':
              eventColor = const Color(0xffF468B7);
              sizedBoxAttribute = 20.0;
              sizedBoxStatus = 6.0;
              break;
            case 'HADIR':
              eventColor = const Color(0xff5FD0D3);
              sizedBoxAttribute = 20.0;
              sizedBoxStatus = 0.0;
              break;
            case 'IZIN':
              eventColor = const Color(0xffFEC85C);
              sizedBoxAttribute = 20.0;
              sizedBoxStatus = 6.0;
              break;
            case 'SAKIT':
              eventColor = const Color(0xff8D7AEE);
              sizedBoxAttribute = 20.0;
              sizedBoxStatus = 0.0;
              break;
            default:
              eventColor = Colors.grey;
          }

          final timeFormat = DateFormat('HH:mm');
          final formattedTime = timeFormat.format(events[index].record);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border:
                  Border.all(color: eventColor), // Use event color for border
              borderRadius: BorderRadius.circular(12),
              color: eventColor
                  .withOpacity(0.1), // Light background color based on status
            ),
            child: ListTile(
              title: Row(
                children: [
                  SizedBox(
                    width: sizedBoxStatus,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      events[index].namaKeterangan,
                      style: GoogleFonts.plusJakartaSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: eventColor,
                            ),
                          ),
                    ),
                  ),
                  SizedBox(
                    width: sizedBoxStatus,
                  ),
                  Container(
                    width: 5,
                    height: 30,
                    decoration: BoxDecoration(
                      color: eventColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  SizedBox(
                    width: sizedBoxAttribute,
                  ),
                  Text(
                    formattedTime,
                    style: TextStyle(color: eventColor),
                  ),
                  SizedBox(
                    width: sizedBoxAttribute,
                  ),
                  Center(
                    child: Row (
                      children: [
                        Text(
                          events[index].nis,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: eventColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
