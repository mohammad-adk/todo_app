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
  List<String> _repeat = [];
  String _repeatText;
  DateTime _selectedDate;
  TimeOfDay _selectedTime;

  void _submitData() {
    Provider.of<Tasks>(context, listen: false).addTasks(
      Task(
        title: _titleController.value.text,
        deadLine: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day,_selectedTime.hour, _selectedTime.minute),
        notes: _notesController.value.text,
        repeats: _repeat,
      ),
    );
    Navigator.of(context).pop();
  }

  Widget weekButton(String day, List<String> _localRepeat) {
    var isChecked = _localRepeat.contains(day);
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
      return FlatButton(
        child: Container(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                day,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              Checkbox(
                value: isChecked,
                onChanged: (_) {
                  setModalState(() {
                  if (isChecked){
                    _localRepeat.remove(day);}
                  else{
                    _localRepeat.add(day);
                  }
                    isChecked = !isChecked;
                  });
                },
              ),
            ],
          ),
        ),
        onPressed: () {
          setModalState(() {
            if (isChecked){
              _localRepeat.remove(day);}
            else{
              _localRepeat.add(day);
            }
            isChecked = !isChecked;
          });
        },
      );
    });
  }

  void customRepeatBottomSheet() {
    List<String> _localRepeat = [];
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
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Repeat',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                  weekButton('Saturday',_localRepeat),
                  weekButton('Sunday',_localRepeat),
                  weekButton('Monday',_localRepeat),
                  weekButton('Tuesday',_localRepeat),
                  weekButton('Wednesday',_localRepeat),
                  weekButton('Thursday',_localRepeat),
                  weekButton('Friday',_localRepeat),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Done',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Icon(
                              Icons.done_outline,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        onPressed: () {
                          _repeat = _localRepeat;
                          _repeatText = 'Custom';
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
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
                  SizedBox(
                    height: 30,
                  ),
                  Divider(height: 1, thickness: 1,),
                  Row(
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Once',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.end,
                        ),
                        onPressed: () {
                          setState(() {
                            _repeatText = 'Once';
                          });
                          _repeat = [];
                          Navigator.of(bCtx).pop();
                        },
                      ),
                    ],
                  ),
                  Divider(height: 1, thickness: 1,),
                  Row(
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Daily',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.end,
                        ),
                        onPressed: () {
                          setState(() {
                            _repeatText = 'Daily';
                          });
                          _repeat = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Divider(height: 1, thickness: 1,),
                  Row(

                    children: <Widget>[
                      SizedBox(width: 6,),
                      FlatButton(
                        child: Text(
                          'Mon to Fri',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.right,
                        ),
                        onPressed: () {
                          setState(() {
                            _repeatText = 'Mon to Fri';
                          });
                          _repeat = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Divider(height: 1, thickness: 1,),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 6,),
                      FlatButton(
                        child: Text(
                          'Custom',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.end,
                        ),
                        onPressed: customRepeatBottomSheet,
                      ),
                    ],
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
                context: context, initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute))
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
                  style: TextStyle(color: Colors.white),
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
