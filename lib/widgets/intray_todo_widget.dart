import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../global.dart';
import '../models/task.dart';


class IntrayTodo extends StatelessWidget {
  final Task task;

  IntrayTodo({this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15, left: 15, right: 15),
      padding: EdgeInsets.all(10),
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          color: redColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            new BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 5,
            )
          ]),
      child: Row(
        children: <Widget>[
          Radio(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                task.title,
                style: darkTodoTitle,
              ),
              Text(
               task.deadLine.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900),
              )
            ],
          )
        ],
      ),
    );
  }
}
