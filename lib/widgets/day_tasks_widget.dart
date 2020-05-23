import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tasks.dart';

class DayTasksWidget extends StatelessWidget {
  final DateTime day;
  final String text;

  const DayTasksWidget(this.day, this.text);

  @override
  Widget build(BuildContext context) {
    final taskCount = Provider.of<Tasks>(context).getTaskOfDayCount(day);
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(top: 5),
            height: 70,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Theme.of(context).accentColor),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),
                  width: 30,
                  height: 5,
                );
              },
              itemCount: taskCount,
            ),

//            Column(
//              children: <Widget>[
//                Container(
//                  margin: EdgeInsets.all(5),
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(10),
//                    color: Colors.black,
//                  ),
//                  width: 30,
//                  height: 5,
//                ),
//                Container(
//                  padding: EdgeInsets.all(19),
//                  margin: EdgeInsets.all(5),
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(10),
//                    color: Colors.black,
//                  ),
//                  width: 30,
//                  height: 5,
//                ),
//                Container(
//                  padding: EdgeInsets.all(19),
//                  margin: EdgeInsets.all(5),
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(10),
//                    color: Colors.black,
//                  ),
//                  width: 30,
//                  height: 5,
//                ),
//              ],
//            )),
//      ],
//    );
            ),
        SizedBox(
          height: 20,
        ),
        Text(text, style: TextStyle(color: Colors.white),)
      ],
    );
  }
}
