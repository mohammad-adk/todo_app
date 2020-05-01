import 'package:flutter/material.dart';

import '../global.dart';
import '../widgets/day_tasks_widget.dart';

class WeekViewPage extends StatefulWidget {
  @override
  _WeekViewPageState createState() => _WeekViewPageState();
}

class _WeekViewPageState extends State<WeekViewPage> {
  @override
  Widget build(BuildContext context) {
    const baseWidth = 5.0;
    const baseHeight = 30.0;
    return Container(
      color: darkGreyColor,
      padding: EdgeInsets.only(top: 200, left: 20),
      child: Stack(children: <Widget>[
        Positioned(
            child:DayTasksWidget(),
          left: baseWidth,
          top: baseHeight,
        ),
        Positioned(
            child:DayTasksWidget(),
          left: baseWidth + 50,
          top: baseHeight + 140,
        ),
        Positioned(
            child:DayTasksWidget(),
          left: baseWidth + 100,
          top: baseHeight,
        ),
        Positioned(
            child:DayTasksWidget(),
          left: baseWidth + 150,
          top: baseHeight + 140,
        ),
        Positioned(
            child:DayTasksWidget(),
          left: baseWidth + 200,
          top: baseHeight,
        ),
        Positioned(
            child:DayTasksWidget(),
          left: baseWidth + 250,
          top: baseHeight + 140,
        ),
        Positioned(
            child:DayTasksWidget(),
          left: baseWidth + 300,
          top: baseHeight,
        ),
      ],)
    );
  }
}
