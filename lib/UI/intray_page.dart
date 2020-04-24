import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../global.dart';
import '../widgets/intray_todo_widget.dart';
import '../providers/tasks.dart';

class IntrayPage extends StatefulWidget {
  @override
  _IntrayPageState createState() => _IntrayPageState();
}

class _IntrayPageState extends State<IntrayPage> {
  List<Task> taskList = [];
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<Tasks>(context, listen: false).fetchAndSetTasks().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    taskList = getList();
    return  Provider(
      create: (_) => Tasks(),
      child: Container(
          color: darkGreyColor,
          child: _isLoading ? Center(
            child: CircularProgressIndicator(),
          ) : _buildReorderableListSimple(context, taskList)),
    );
  }

  Widget _buildListTile(BuildContext context, Task item) {
    return ListTile(
      key: Key(item.taskID),
      title: Dismissible(
        key: Key(item.taskID),
        onDismissed: (direction){
          Provider.of<Tasks>(context,listen: false).deleteTask(item.taskID);
        },
        child: IntrayTodo(
          task: item,
        ),
      ),
    );
  }

  Widget _buildReorderableListSimple(
      BuildContext context, List<Task> taskList) {
    return  Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 250),
        itemBuilder: (ctx, index){
          return _buildListTile(context, taskList[index]);
        },
        itemCount: taskList.length,
//        taskList.map((Task item) => _buildListTile(context, item)).toList(),
      ),
    );
  }

  List<Task> getList() {
//    taskList = Provider.of<Tasks>(context).tasks;
//    return Provider.of<Tasks>(context).tasks;
    if (Provider.of<Tasks>(context).tasks.length != 0 && taskList.length != 0) {
      return Provider
          .of<Tasks>(context)
          .tasks;
    } else {
      taskList = [];
      for (int i = 0; i < 15; i++) {
        taskList.add(
          Task(
            title: "Todo number" + i.toString(),
            deadLine: DateTime.now().add(Duration(days: 1),),
            notes: 'Test Text ',
            repeats: [],
          ),
        );
      }
      return taskList;
    }
  }
}
