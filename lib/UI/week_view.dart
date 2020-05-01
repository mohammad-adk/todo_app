import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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
    const baseWidth = 25.0;
    const baseHeight = 130.0;
    return Container(
      color: darkGreyColor,
      padding: EdgeInsets.only(top: 100),
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
        DraggableScrollableSheet(
          initialChildSize: 0.23,
          minChildSize: 0.23,
          maxChildSize: 0.6,
          builder: (context, controller ){
            return Container(
              padding: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
              color: redColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(50))
              ),
              child: Theme(
                data: ThemeData(accentColor: redColor),
                child: ListView.builder( itemBuilder: (BuildContext context, index){
                  return ListTile(title: Text('index : $index'),);
                }, itemCount: 250, controller: controller,),
              ),
            );
          },
        )
      ],)
    );
  }
}
