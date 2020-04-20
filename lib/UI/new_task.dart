import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tasks.dart';
import '../models/task.dart';

class NewTask extends StatefulWidget {
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final _titleController = TextEditingController();
  DateTime _selectedDate;

//  final _amountController = TextEditingController();

  void _submitData() {
    Provider.of<Tasks>(context,listen: false).addTasks(
      Task(
        title: _titleController.value.text,
        deadLine: _selectedDate,
      ),
    );
//    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom:
          MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _selectedDate == null
                          ? "No date chosen."
                          : "Chosen Date: ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    FlatButton(
                      child: Text(
                        'Choose date',
                      ),
                      textColor: Colors.purple,
                      onPressed: _presentDatePicker,
                    ),
                  ],
                ),
              ),
              RaisedButton(
                child: Text("Add transaction"),
                textColor: Colors.white,
                color: Colors.purple,
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
