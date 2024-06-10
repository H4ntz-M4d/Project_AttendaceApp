import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_attendance_app/Screen/record/bar_chart.dart';
import 'package:project_attendance_app/Screen/record/chart.dart';
import 'package:project_attendance_app/Screen/record/indicator.dart';
import 'package:project_attendance_app/api_connection/api_connection.dart';
import 'package:project_attendance_app/coba.dart';
import 'package:project_attendance_app/user/model/user.dart';
import 'package:project_attendance_app/user/userPreferences/user_preferences.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:http/http.dart' as http;

class RecordDetailPage extends StatefulWidget {
  const RecordDetailPage({super.key});

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  Future<List<int>> getCountRecordsInfo() async {
    try {
      Siswa? siswa = await RememberUserPrefs.readUserInfo();
      final results = await http
          .post(Uri.parse(API.getCountTotalRecords), body: {"nis": siswa?.nis});
      var resultsDecode = json.decode(results.body)['userData'];
      return [
        int.parse(resultsDecode['jumlah_hadir']),
        int.parse(resultsDecode['jumlah_sakit']),
        int.parse(resultsDecode['jumlah_izin']),
        int.parse(resultsDecode['jumlah_alpha']),
      ];
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_function_declarations_over_variables
    final page = ({required Widget child}) => Styled.widget(child: child)
        .padding(vertical: 30, horizontal: 20)
        .constrained(minHeight: MediaQuery.of(context).size.height - (2 * 30))
        .scrollable();
    return Builder(
      builder: (context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        return Scaffold(
          appBar: AppBar(
            title: Text('Grafik Absensi'),
          ),
          drawer: DrawerNavigation(),
          body: <Widget>[
            <Widget>[
              Text(
                'Grafik Record',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              FutureBuilder<List<int>>(
                future: getCountRecordsInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return PieChartSample3(data: snapshot.data!);
                  } else {
                    return Text('No data available');
                  }
                },
              ),
            ]
                .toColumn(mainAxisAlignment: MainAxisAlignment.spaceAround)
                .padding(horizontal: 20, vertical: 10)
                .decorated(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(20))
                .elevation(
                  5,
                  shadowColor: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                )
                .alignment(Alignment.topCenter),
            const SizedBox(
              height: 25,
            ),
            <Widget>[
              FutureBuilder<List<int>>(
                future: getCountRecordsInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return BarChartRecord(data: snapshot.data!);
                  } else {
                    return Text('No data available');
                  }
                },
              ),
            ]
                .toColumn(mainAxisAlignment: MainAxisAlignment.spaceAround)
                .padding(horizontal: 20, bottom: 10, top: 40)
                .decorated(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(20))
                .elevation(
                  5,
                  shadowColor: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                )
                .alignment(Alignment.topCenter),
            const SizedBox(
              height: 25,
            ),
            <Widget>[
              <Widget>[
                const Indicator(
                  color: Color(0xff5FD0D3),
                  text: 'Hadir',
                  isSquare: false,
                ),
                const Indicator(
                  color: Color(0xff8D7AEE),
                  text: 'Sakit',
                  isSquare: false,
                ),
                const Indicator(
                  color: Color(0xffFEC85C),
                  text: 'Izin',
                  isSquare: false,
                ),
                const Indicator(
                  color: Color(0xffF468B7),
                  text: 'Alpha',
                  isSquare: false,
                ),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceAround),
            ]
                .toColumn(mainAxisAlignment: MainAxisAlignment.spaceAround)
                .padding(horizontal: 20, vertical: 10)
                .decorated(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(20))
                .elevation(
                  5,
                  shadowColor: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                )
                .alignment(Alignment.topCenter),
          ].toColumn().parent(page),
        );
      },
    );
  }
}
