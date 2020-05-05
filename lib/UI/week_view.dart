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
      lowerBound: 0,
      upperBound: 140,
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
    bool init = true;
    return Container(
        color: darkGreyColor,
        padding: EdgeInsets.only(top: 100),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: DayTasksWidget(DateTime.now(), 'Sat'),
              left: baseWidth,
              top: baseHeight,
            ),
            AnimatedBuilder(
              animation: _scrollController,
              builder: (context, child) {
                return Positioned(
                  child: DayTasksWidget(
                      DateTime.now().add(Duration(days: 1)), 'Sun'),
                  left: baseWidth + 50,
                  top: baseHeight + 140 - _scrollController.value,
                );
              },
            ),
            Positioned(
              child:
                  DayTasksWidget(DateTime.now().add(Duration(days: 2)), 'Mon'),
              left: baseWidth + 100,
              top: baseHeight,
            ),
            Positioned(
              child:
                  DayTasksWidget(DateTime.now().add(Duration(days: 3)), 'Tue'),
              left: baseWidth + 150,
              top: baseHeight + 140 - _scrollController.value,
            ),
            Positioned(
              child:
                  DayTasksWidget(DateTime.now().add(Duration(days: 4)), 'Wed'),
              left: baseWidth + 200,
              top: baseHeight,
            ),
            Positioned(
              child:
                  DayTasksWidget(DateTime.now().add(Duration(days: 5)), 'Thu'),
              left: baseWidth + 250,
              top: baseHeight + 140 - _scrollController.value,
            ),
            Positioned(
              child:
                  DayTasksWidget(DateTime.now().add(Duration(days: 6)), "Fri"),
              left: baseWidth + 300,
              top: baseHeight,
            ),
            NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification) {

                }
                return true;
              },
              child: DraggableScrollableSheet(
                initialChildSize: 0.20,
                minChildSize: 0.2,
                maxChildSize: 0.65,
                builder: (context, controller) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!init) {
                  double position = (controller.position.viewportDimension - 120) / 1.85;
                      setState(() {
                        _scrollController.value = position;
                      });
                      print(controller.position.viewportDimension);
                      print('scroll ${_scrollController.value}');
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
