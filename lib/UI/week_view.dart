import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../global.dart';
import '../widgets/day_tasks_widget.dart';

class WeekViewPage extends StatefulWidget {
  @override
  _WeekViewPageState createState() => _WeekViewPageState();
}

class _WeekViewPageState extends State<WeekViewPage>
    with SingleTickerProviderStateMixin {
  RelativeRectTween relativeRectTween;

  AnimationController _scrollController;

  @override
  void initState() {
    _scrollController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    relativeRectTween = RelativeRectTween(
      begin: RelativeRect.fromLTRB(0, 270, 0, 0),
      end: RelativeRect.fromLTRB(0, 130, 0, 0),
    )..animate(_scrollController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const baseWidth = 25.0;
    const baseHeight = 130.0;
    return Container(
        color: darkGreyColor,
        padding: EdgeInsets.only(top: 100),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: DayTasksWidget(DateTime.now()),
              left: baseWidth,
              top: baseHeight,
            ),
            Positioned(
              child: DayTasksWidget(DateTime.now().add(Duration(days: 1))),
              left: baseWidth + 50,
              top: baseHeight + 140,
            ),
            Positioned(
              child: DayTasksWidget(DateTime.now().add(Duration(days: 2))),
              left: baseWidth + 100,
              top: baseHeight,
            ),
            PositionedTransition(
              rect: relativeRectTween.animate(_scrollController),
              child: DayTasksWidget(DateTime.now().add(Duration(days: 3))),
//              left: baseWidth + 150,
//              top: baseHeight + 140 - _scrollController.value,
            ),
            Positioned(
              child: DayTasksWidget(DateTime.now().add(Duration(days: 4))),
              left: baseWidth + 200,
              top: baseHeight,
            ),
            Positioned(
              child: DayTasksWidget(DateTime.now().add(Duration(days: 5))),
              left: baseWidth + 250,
              top: baseHeight + 140 - _scrollController.value,
            ),
            Positioned(
              child: DayTasksWidget(DateTime.now().add(Duration(days: 6))),
              left: baseWidth + 300,
              top: baseHeight,
            ),
            NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification){
                if (scrollNotification is ScrollUpdateNotification) {
                  print(scrollNotification.scrollDelta);
                }
                return true;
              },
              child: DraggableScrollableSheet(
                initialChildSize: 0.20,
                minChildSize: 0.2,
                maxChildSize: 0.6,
                builder: (context, controller) {
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
                              title: Text('index : $index'),
                            );
                          },
                          itemCount: 41,
                          controller: controller,
                        ),
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
