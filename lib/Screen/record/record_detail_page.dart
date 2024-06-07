import 'package:flutter/material.dart';
import 'package:project_attendance_app/Screen/record/bar_chart.dart';
import 'package:project_attendance_app/Screen/record/chart.dart';
import 'package:project_attendance_app/Screen/record/indicator.dart';
import 'package:project_attendance_app/coba.dart';
import 'package:styled_widget/styled_widget.dart';

class RecordDetailPage extends StatefulWidget {
  const RecordDetailPage({super.key});

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
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
            const <Widget>[
              Text(
                'Grafik Record',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              PieChartSample3(),
            ]
                .toColumn(mainAxisAlignment: MainAxisAlignment.spaceAround)
                .padding(horizontal: 20, vertical: 10)
                .decorated(
                    color: Colors.white,
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
            const <Widget>[
              Text(
                'Grafik Record',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              BarChartRecord(),
            ]
                .toColumn(mainAxisAlignment: MainAxisAlignment.spaceAround)
                .padding(horizontal: 20, vertical: 10)
                .decorated(
                    color: Colors.white,
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
                    color: Colors.white,
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
