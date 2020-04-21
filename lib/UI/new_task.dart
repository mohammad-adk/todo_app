import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/tasks.dart';
import '../models/task.dart';
import '../global.dart';

class NewTask extends StatefulWidget {
  static const routeName = '/newTask';

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  String _repeat;
  String _repeatText;
  DateTime _selectedDate;
  TimeOfDay _selectedTime;

//  final _amountController = TextEditingController();

  void _submitData() {
    Provider.of<Tasks>(context, listen: false).addTasks(
      Task(
        title: _titleController.value.text,
        deadLine: _selectedDate,
        notes: _notesController.value.text,
      ),
    );
    Navigator.of(context).pop();
  }

  Widget weekButton(String day) {
    bool value = true;
    return FlatButton(
      child: Container(
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              day,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
            ),
            Checkbox(
              value: value,
              onChanged: (_) {},
            )
          ],
        ),
      ),
      onPressed: () {
        setState(() {
          value = !value;
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      },
    );
  }

  void customRepeatBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0),
      context: context,
      builder: (ctx) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
                color: darkGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Repeat', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),),
                  ),
                  weekButton('Saturday'),
                  weekButton('Sunday'),
                  weekButton('Monday'),
                  weekButton('Tuesday'),
                  weekButton('Wednesday'),
                  weekButton('Thursday'),
                  weekButton('Friday'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _repeatBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
        context: context,
        builder: (bCtx) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: Container(
              decoration: BoxDecoration(
                color: darkGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30,),
                  FlatButton(
                    child: Text(
                      'Once',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    onPressed: () {
                      setState(() {
                        _repeatText = 'Once';
                      });
                      _repeat = '';
                      Navigator.of(bCtx).pop();
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Daily',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    onPressed: () {
                      setState(() {
                        _repeatText = 'Daily';
                      });
                      _repeat = 'Sun Mon Tue Wed Thu Fri Sat';
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Mon to Fri',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    onPressed: () {
                      setState(() {
                        _repeatText = 'Mon to Fri';
                      });
                      _repeat = 'Mon Tue Wed Thu Fri';
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Custom',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    onPressed: customRepeatBottomSheet,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            initialDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 365)),
            initialDatePickerMode: DatePickerMode.day)
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        showTimePicker(
                context: context, initialTime: TimeOfDay(hour: 12, minute: 0))
            .then((pickedTime) {
          if (pickedTime == null) {
            return;
          }
          setState(() {
            _selectedDate = pickedDate;
            _selectedTime = pickedTime;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGreyColor,
      appBar: AppBar(
        title: Text('Add a New Task'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  controller: _titleController,
                  onSubmitted: (_) => _submitData(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    suffixStyle: TextStyle(color: Colors.white),
                    labelText: "Notes",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    counterStyle: TextStyle(color: Colors.white),
                  ),
                  controller: _notesController,
                  onSubmitted: (_) => _submitData(),
                  maxLines: 3,
                  maxLengthEnforced: true,
                  maxLength: 300,
                ),
              ),
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _selectedDate == null
                          ? "No date chosen."
                          : "Chosen Date: ${DateFormat('dd MMM yyyy').format(_selectedDate)}",
                      style: TextStyle(color: Colors.grey, fontSize: 17),
                    ),
                    FlatButton(
                      child: Text(
                        'Choose date & time',
                      ),
                      textColor: Colors.purple,
                      onPressed: _presentDatePicker,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _selectedTime == null
                        ? "No time chosen"
                        : 'chosen time : ${_selectedTime.hour} : ${_selectedTime.minute}',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Repeat',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  FlatButton(
                    child: Row(
                      children: <Widget>[
                        Text(
                          _repeatText == null ? 'Once' : _repeatText,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    onPressed: _repeatBottomSheet,
                  )
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitData,
        child: Icon(Icons.done),
      ),
    );
  }
}
