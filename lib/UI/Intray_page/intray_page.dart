import 'package:flutter/material.dart';
import 'package:todo_app/models/classes/task.dart';
import 'package:todo_app/models/global.dart';
import 'package:todo_app/models/widgets/intray_todo_widget.dart';

class IntrayPage extends StatefulWidget {
  @override
  _IntrayPageState createState() => _IntrayPageState();
}

class _IntrayPageState extends State<IntrayPage> {
  List<Task> taskList = [];

  @override
  Widget build(BuildContext context) {
    taskList = getList();
    return Container(
      color: darkGreyColor,
      child: _buildReorderableListSimple(context, taskList)
      );
  }

 Widget _buildListTile(BuildContext context, Task item) {
    return ListTile(
      key: Key(item.taskID.toString()),
      title: IntrayTodo(
        title: item.title,
      ),
    );
  }

  Widget _buildReorderableListSimple(
    BuildContext context, List<Task> taskList) {
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: ReorderableListView(
        // handleSide: ReorderableListSimpleSide.Right,
        // handleIcon: Icon(Icons.access_alarm),
        padding: EdgeInsets.only(top: 300.0),
        children:
            taskList.map((Task item) => _buildListTile(context, item)).toList(),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            Task item = taskList[oldIndex];
            taskList.remove(item);
            taskList.insert(newIndex, item);
          });
        },
      ),
    );
  }

List<Task> getList(){
  if (taskList.length != 0){
    return taskList;
  }
  else{
  for (int i = 0; i < 15 ; i++){
    taskList.add(Task(
      title: "Todo number" + i.toString(),
       completed: false,
        taskID: i.toString()));
  }
  return taskList;
}
}
}