import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project_attendance_app/user/userPreferences/record_preferences.dart';
import 'package:styled_widget/styled_widget.dart';

// ignore: must_be_immutable
class _BarChart extends StatelessWidget {
  int hadir = 0;
  int sakit = 0;
  int izin = 0;
  int alpha = 0;

  _BarChart();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RememberRecordPrefs.getRememberAbsensi(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Tampilkan spinner saat menunggu data
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Tampilkan pesan error jika ada
        } else {
          for (var record in snapshot.data!) {
            switch (record.kodeKeterangan) {
              case 'HD':
                hadir++;
                break;
              case 'SK':
                sakit++;
                break;
              case 'ZN':
                izin++;
                break;
              case 'PH':
                alpha++;
                break;
            }
          }
          return BarChart(
            BarChartData(
              barTouchData: barTouchData,
              titlesData: titlesData,
              borderData: borderData,
              barGroups: barGroups,
              gridData: const FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              maxY: 7,
            ),
          ); // Tampilkan data setelah selesai
        }
      },
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipColor: (group) => Colors.transparent,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            // Daftar warna untuk tooltips
            List<Color> tooltipColors = [
              Colors.purple,
              Colors.pink,
              Colors.orange,
              Colors.blue
            ];

            // Ambil warna berdasarkan indeks
            Color tooltipColor =
                tooltipColors[groupIndex % tooltipColors.length];

            return BarTooltipItem(
              rod.toY.round().toString(),
              TextStyle(
                color: tooltipColor,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    String text;
    Color color;
    switch (value.toInt()) {
      case 0:
        text = 'Hadir';
        color = Colors.purple.shade900;
        break;
      case 1:
        text = 'Sakit';
        color = Colors.red.shade900;
        break;
      case 2:
        text = 'Izin';
        color = Colors.orange.shade900;
        break;
      case 3:
        text = 'Alpha';
        color = Colors.blue.shade900;
        break;
      default:
        text = '';
        color = Colors.blue.shade900;
        break;
    }
    final style = TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          Colors.purple.shade900,
          Colors.purple.shade200,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
  LinearGradient get _barsGradient2 => LinearGradient(
        colors: [
          Colors.pink.shade900,
          Colors.red.shade200,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
  LinearGradient get _barsGradient3 => LinearGradient(
        colors: [
          Colors.orange.shade900,
          Colors.orange.shade200,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
  LinearGradient get _barsGradient4 => LinearGradient(
        colors: [
          Colors.blue.shade900,
          Colors.blue.shade200,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: hadir.toDouble(),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: sakit.toDouble(),
              gradient: _barsGradient2,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: izin.toDouble(),
              gradient: _barsGradient3,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: alpha.toDouble(),
              gradient: _barsGradient4,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];
}

class BarChartRecord extends StatefulWidget {
  const BarChartRecord({super.key});

  @override
  State<StatefulWidget> createState() => BarChartRecordState();
}

class BarChartRecordState extends State<BarChartRecord> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: _BarChart(),
    );
  }
}
