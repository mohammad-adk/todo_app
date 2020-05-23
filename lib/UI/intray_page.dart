import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../widgets/intray_todo_widget.dart';
import '../providers/tasks.dart';

class IntrayPage extends StatefulWidget {
  @override
  _IntrayPageState createState() => _IntrayPageState();
}

class _IntrayPageState extends State<IntrayPage> {
  List<Task> taskList = [];
  bool _isLoading = false;
  bool isDisposed = false;
  bool isInit = true;

  @override
  void initState() {

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      _isLoading = true;
      Provider.of<Tasks>(context, listen: false).fetchAndSetTasks().then((_) {
        if (!isDisposed) {
          setState(() {
            _isLoading = false;
          });
        } else {
          return;
        }
      });
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    taskList = getList();
    return Container(
        color: Theme.of(context).primaryColor,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : taskList.isEmpty
                ? Center(
                    child: Text(
                      'You have no notes!',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(top: 250),
                    itemBuilder: (ctx, index) {
                      return _buildListTile(context, taskList[index]);
                    },
                    itemCount: taskList.length,
                    cacheExtent: 100,
                  ));
  }

  Widget _buildListTile(BuildContext context, Task item) {
    return  Dismissible(
        key: Key(item.taskID),
        onDismissed: (direction) {
          Provider.of<Tasks>(context, listen: false).deleteTask(item.taskID);
        },
        child: ListTile(
          key: Key(item.taskID),
          title:HomeTodo(
          task: item,
        ),),
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            size: 40,
            color: Colors.white,
          ),
          alignment: Alignment.centerLeft,
//          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        ),
        direction: DismissDirection.startToEnd,
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Are you sure'),
                content:
                Text('Do you want to remove the note?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              ));
        },
    );
  }

  List<Task> getList() {
    taskList = Provider.of<Tasks>(context).tasks;
    return taskList;
  }
}
