import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tasks.dart';
import '../global.dart';

class DayTasksWidget extends StatelessWidget {
//  final DateTime day;
//
//  DayTasksWidget(this.day);

  @override
  Widget build(BuildContext context) {
//    final taskCount = Provider.of<Tasks>(context).getTaskOfDayCount(day);
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 5),
            height: 70,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: redColor),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),
                  width: 30,
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.all(19),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),
                  width: 30,
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.all(19),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),
                  width: 30,
                  height: 5,
                ),
              ],
            )),
        SizedBox(
          height: 20,
        ),
        Text("Sun", style: TextStyle(color: Colors.white),)
      ],
    );
  }
}
