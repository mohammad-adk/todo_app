import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'intray_page.dart';
import '../global.dart';
import './new_task.dart';
import './settings_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  static const routeName = '/homaPage';
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController _tabController;
  AnimationController _opacityController;
  static const minDragStartEdge = 5.0;
  static const maxDragStartEdge = 10.0;
  bool _canBeDragged;

  double maxSlide = 300.0;

  @override
  void initState() {
    super.initState();
    _opacityController = AnimationController(
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
      duration: Duration(
        milliseconds: 200,
      ),
    );
    _tabController = TabController(vsync: this, length: 3, initialIndex: 1);
    _opacityController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = _opacityController.isDismissed &&
        details.globalPosition.dx < minDragStartEdge;
    bool isDragCloseFromRight = _opacityController.isCompleted &&
        details.globalPosition.dx > maxDragStartEdge;

    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      _opacityController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_opacityController.isDismissed || _opacityController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx >= 365.0) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;
      _opacityController.fling(velocity: visualVelocity);
    } else if (_opacityController.value < 0.5) {
      _opacityController.reverse(from: _opacityController.value);
    } else {
      _opacityController.forward(from: _opacityController.value);
    }
  }

  void toggle(index) {
    switch (index){
      case 0 : _opacityController.reverse();break;
      case 1 : _opacityController.forward();break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.yellow,
      home: SafeArea(
        top: true,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
               TabBarView(
                 key: Key('tabbar'),
                  controller: _tabController,
                  children: [
                    Container(
                      color: Colors.blueGrey,
                    ),
            GestureDetector(
                onHorizontalDragStart: _onDragStart,
                onHorizontalDragUpdate: _onDragUpdate,
                onHorizontalDragEnd: _onDragEnd,
                child: IntrayPage()),
                    SettingsPage(),
                  ],
                ),
          FadeTransition(
            opacity: ReverseAnimation(_opacityController),
            child: calendar(context),
          ),
          FadeTransition(
            opacity: _opacityController,
            child: intray(context),
          ),
            ],
          ),
          appBar: AppBar(
            elevation: 0,
            title: TabBar(
              onTap: (index) => toggle(index),
              controller: _tabController,
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                ),
                Tab(
                  icon: Icon(Icons.rss_feed),
                ),
                Tab(
                  icon: Icon(Icons.perm_identity),
                )
              ],
              labelColor: darkGreyColor,
              unselectedLabelColor: Colors.blue,
            ),
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}

Widget intray(BuildContext context) {
  return Stack(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(left: 50),
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60)),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Intray", style: intrayTitleTextStyle),
            Container()
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(
            top: 120, left: (MediaQuery.of(context).size.width) / 2 - 40),
        width: 80,
        height: 80,
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () => Navigator.pushNamed(context, NewTask.routeName),
          child: Icon(
            Icons.add,
            size: 50,
          ),
        ),
      ),
    ],
  );
}

Widget calendar(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(left: 50),
    height: 160,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
      color: Colors.white,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Home", style: intrayTitleTextStyle),
        Container()
      ],
    ),
  );
}
