import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';

import '../global.dart';
import '../widgets/day_tasks_widget.dart';
import '../models/task.dart';
import '../providers/tasks.dart';

class WeekViewPage extends StatefulWidget {
  @override
  _WeekViewPageState createState() => _WeekViewPageState();
}

class _WeekViewPageState extends State<WeekViewPage>
    with SingleTickerProviderStateMixin {
  AnimationController _scrollController;
  int dayIndex = 0;

  @override
  void initState() {
    _scrollController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      lowerBound: 0,
      upperBound: 140,
    );
    super.initState();
  }

  void dayToggle(int index) {
    if (dayIndex != index) {
      setState(() {
        dayIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const baseWidth = 25.0;
    const baseHeight = 130.0;
    bool init = true;
    List<Task> tasks = Provider.of<Tasks>(context)
        .getTasksOfDay(DateTime.now().add(Duration(days: dayIndex)));
    return Container(
        color: darkGreyColor,
        padding: EdgeInsets.only(top: 100),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: GestureDetector(
                  onTap: () => dayToggle(0),
                  child: DayTasksWidget(DateTime.now(), 'Sat')),
              left: baseWidth,
              top: baseHeight,
            ),
            Positioned(
              child: GestureDetector(
                onTap: () => dayToggle(4),
                child: DayTasksWidget(
                    DateTime.now().add(Duration(days: 4)), 'Wed'),
              ),
              left: baseWidth + 50 + _scrollController.value * 150,
              top: baseHeight + 140 - _scrollController.value * 140,
            ),
            Positioned(
              child: GestureDetector(
                onTap: () => dayToggle(1),
                child: DayTasksWidget(
                    DateTime.now().add(Duration(days: 1)), 'Sun'),
              ),
              left: baseWidth + 100 - _scrollController.value * 50,
              top: baseHeight,
            ),
            Positioned(
              child: GestureDetector(
                onTap: () => dayToggle(5),
                child: DayTasksWidget(
                    DateTime.now().add(Duration(days: 5)), 'Thu'),
              ),
              left: baseWidth + 150 + _scrollController.value * 100,
              top: baseHeight + 140 - _scrollController.value * 140,
            ),
            Positioned(
              child: GestureDetector(
                onTap: () => dayToggle(2),
                child: DayTasksWidget(
                    DateTime.now().add(Duration(days: 2)), 'Mon'),
              ),
              left: baseWidth + 200 - _scrollController.value * 100,
              top: baseHeight,
            ),
            Positioned(
              child: GestureDetector(
                onTap: () => dayToggle(6),
                child: DayTasksWidget(
                    DateTime.now().add(Duration(days: 6)), 'Fri'),
              ),
              left: baseWidth + 250 + _scrollController.value * 50,
              top: baseHeight + 140 - _scrollController.value * 140,
            ),
            Positioned(
              child: GestureDetector(
                onTap: () => dayToggle(3),
                child: DayTasksWidget(
                    DateTime.now().add(Duration(days: 3)), 'Tue'),
              ),
              left: baseWidth + 300- _scrollController.value * 150,
              top: baseHeight,
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.20,
              minChildSize: 0.2,
              maxChildSize: 0.6,
              builder: (context, controller) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!init) {
                    double position =
                        (controller.position.viewportDimension - 112) / 245;
                    setState(() {
                      _scrollController.value = position;
                    });
                    print(_scrollController.value);
                  }
                  init = false;
                });

                return Container(
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: redColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(50))),
                  child: Theme(
                    data: ThemeData(accentColor: redColor),
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, index) {
                        return ListTile(
                          title: Text('Title: ${tasks[index].title}'),
                          subtitle: Text('Notes: ${tasks[index].notes}'),
                        );
                      },
                      itemCount: tasks.length,
                      controller: controller,
                    ),
                  ),
                );
              },
            ),
          ],
        ));
  }
}
