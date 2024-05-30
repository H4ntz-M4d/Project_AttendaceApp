import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class DetailAbsen extends StatefulWidget {
  const DetailAbsen({super.key});

  @override
  State<DetailAbsen> createState() => _DetailAbsenState();
}

class _DetailAbsenState extends State<DetailAbsen> {

  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay){
    setState(() {
      today = day;
    });
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
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text('Selected Day = ' + today.toString().split(" ")[0]),
          
              Container(
                child: TableCalendar(
                  locale: "en_US",
                  rowHeight: 43,
                  headerStyle: 
                    const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                  focusedDay: today,
                  selectedDayPredicate: (day)=>isSameDay(day, today),
                  firstDay: DateTime.utc(2018,01,01),
                  lastDay: DateTime.utc(2045,12,30),
                  onDaySelected: _onDaySelected,
                ),  
              )
            ],
          ),
        ),
      ),
    );
  }
}
