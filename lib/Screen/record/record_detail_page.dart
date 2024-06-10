import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker2/month_year_picker2.dart';
import 'package:project_attendance_app/Screen/record/bar_chart.dart';
import 'package:project_attendance_app/Screen/record/chart.dart';
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
  final tglLahirController = TextEditingController();
  DateTime selectedDate = DateTime.now();

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

  Future<void> _selectDate() async {
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
      builder: (context, child) {
        final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
        final dialogBackgroundColor =
            isDarkTheme ? Color(0xFF1B2339) : Colors.white;
        final textColor = isDarkTheme ? Colors.white : Color(0xFF1B2339);

        return Center(
          child: SizedBox(
            width: 420.0, // Sesuaikan lebar dialog
            height: 520.0, // Sesuaikan tinggi dialog
            child: Theme(
              data: Theme.of(context).copyWith(
                dialogBackgroundColor: dialogBackgroundColor,
                textTheme: TextTheme(
                  headlineLarge: TextStyle(color: textColor),
                  bodyMedium: TextStyle(color: textColor),
                ),
              ),
              child: child!,
            ),
          ),
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        tglLahirController.text = DateFormat('MM-yyyy', 'id_ID')
            .format(picked); // Format tanggal untuk Indonesia
      });
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
            title: const Text('Grafik Absensi'),
          ),
          drawer: const DrawerNavigation(),
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
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return PieChartSample3(data: snapshot.data!);
                  } else {
                    return const Text('No data available');
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
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return BarChartRecord(data: snapshot.data!);
                  } else {
                    return const Text('No data available');
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
            Center(
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20),
                shadowColor: Colors.black,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize
                        .min, // Ensures the column takes up only the necessary space
                    children: [
                      TextFormField(
                        controller: tglLahirController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () {
                              _selectDate();
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Isi Tanggal Lahir";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ].toColumn().parent(page),
        );
      },
    );
  }
}
