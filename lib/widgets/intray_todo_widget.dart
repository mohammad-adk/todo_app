import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/tasks.dart';

import '../global.dart';
import '../models/task.dart';

class HomeTodo extends StatefulWidget {
  final Task task;

  HomeTodo({this.task});

  @override
  _HomeTodoState createState() => _HomeTodoState();
}

class _HomeTodoState extends State<HomeTodo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
      padding: const EdgeInsets.all(10),
      height: 100,
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 5,
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.task.title,
                style: darkTodoTitle,
              ),
              Text(
                DateFormat('yyyy MMM dd').format(widget.task.deadLine),
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
              )
            ],
          ),
          widget.task.completed == true
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.done_outline),
              )
             : Checkbox(
                checkColor: Theme.of(context).primaryColor,
                  value: widget.task.completed,
                  onChanged: (value) {
                    setState(() {
                      widget.task.completed = value;
                    });
              Provider.of<Tasks>(context,listen: false).updateTask(widget.task.taskID, widget.task);
                  },
                )
        ],
      ),
    );
  }
}
