import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../global.dart';
import '../models/task.dart';

class HomeTodo extends StatelessWidget {
  final Task task;

  HomeTodo({this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
      padding: const EdgeInsets.all(10),
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          color: redColor,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
             BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 5,
            )
          ]),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                task.title,
                style: darkTodoTitle,
              ),
              Text(
                DateFormat('yyyy MMM dd').format(task.deadLine),
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
              )
            ],
          ),
        ],
      ),
    );
  }
}
