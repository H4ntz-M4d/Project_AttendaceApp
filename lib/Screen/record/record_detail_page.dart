import 'package:flutter/material.dart';
import 'package:project_attendance_app/Screen/record/chart.dart';
import 'package:styled_widget/styled_widget.dart';

class RecordDetailPage extends StatefulWidget {
  const RecordDetailPage({super.key});

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  @override
  Widget build(BuildContext context) {
    final page = ({required Widget child}) => Styled.widget(child: child)
        .padding(vertical: 30, horizontal: 20)
        .constrained(minHeight: MediaQuery.of(context).size.height - (2 * 30))
        .scrollable();
    return const <Widget>[
      BarChartRecord(),
      Text(
        'Minggu 1',
        style: TextStyle(
          color: Color(0xFF42526F),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]
        .toColumn(mainAxisAlignment: MainAxisAlignment.spaceAround)
        .padding(horizontal: 20, vertical: 10)
        .decorated(color: Colors.white, borderRadius: BorderRadius.circular(20))
        .elevation(
          5,
          shadowColor: Colors.black,
          borderRadius: BorderRadius.circular(20),
        )
        .alignment(Alignment.topCenter)
        .parent(page);
  }
}
