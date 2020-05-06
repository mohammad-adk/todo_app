import 'dart:math';

import 'package:flutter/material.dart';

import 'intray_page.dart';
import '../global.dart';
import './new_task.dart';
import './settings_page.dart';
import './week_view.dart';

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
  AnimationController _opacityController2;

//  static const minDragStartEdge = 5.0;
//  static const maxDragStartEdge = 10.0;
//  bool _canBeDragged;

  double maxSlide = 300.0;

  @override
  void initState() {
    super.initState();
    _opacityController = AnimationController(value: 1, vsync: this);
    _opacityController2 = AnimationController(vsync: this);
    _tabController = TabController(vsync: this, length: 3, initialIndex: 1)
      ..animation.addListener(() {
        _opacityController.value = sin(_tabController.animation.value * pi / 2);
        _opacityController2.value =
            sin((_tabController.animation.value - 1) * pi / 2);
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _opacityController.dispose();
    _opacityController2.dispose();
    super.dispose();
  }

//  These codes will be kept here just to remember them
//
//  void _onDragStart(DragStartDetails details) {
//    bool isDragOpenFromLeft = _opacityController.isDismissed &&
//        details.globalPosition.dx < minDragStartEdge;
//    bool isDragCloseFromRight = _opacityController.isCompleted &&
//        details.globalPosition.dx > maxDragStartEdge;
//
//    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
//  }
//
//  void _onDragUpdate(DragUpdateDetails details) {
//    if (_canBeDragged) {
//      double delta = details.primaryDelta / maxSlide;
//      _opacityController.value += delta;
//    }
//  }
//
//  void _onDragEnd(DragEndDetails details) {
//    if (_opacityController.isDismissed || _opacityController.isCompleted) {
//      return;
//    }
//    if (details.velocity.pixelsPerSecond.dx >= 365.0) {
//      double visualVelocity = details.velocity.pixelsPerSecond.dx /
//          MediaQuery.of(context).size.width;
//      _opacityController.fling(velocity: visualVelocity);
//    } else if (_opacityController.value < 0.5) {
//      _opacityController.reverse(from: _opacityController.value);
//    } else {
//      _opacityController.forward(from: _opacityController.value);
//    }
//  }
//
//  void toggle(index) {
//    switch (index) {
//      case 0:
//        _opacityController.reverse();
//        break;
//      case 1:
//        _opacityController.forward();
//        break;
//    }
//  }

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
                controller: _tabController,
                children: [
                  WeekViewPage(),
                  IntrayPage(),
                  SettingsPage(),
                ],
              ),
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 50),
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60)),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            FadeTransition(
                                opacity:
                                    ReverseAnimation(_tabController.animation),
                                child: Text("Week View",
                                    style: intrayTitleTextStyle)),
                            FadeTransition(
                                opacity: _opacityController,
                                child:
                                    Text("Home", style: intrayTitleTextStyle)),
                            FadeTransition(
                                opacity: _opacityController2,
                                child: Text("User Info",
                                    style: intrayTitleTextStyle)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  FadeTransition(
                    opacity: _opacityController,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 90,
                          left: (MediaQuery.of(context).size.width) / 2 - 40),
                      width: 80,
                      height: 80,
                      child: FloatingActionButton(
                        backgroundColor: Colors.red,
                        onPressed: () {
                          if (_tabController.index == 1) {
                            Navigator.pushNamed(context, NewTask.routeName);
                          }
                        },
                        child: const Icon(
                          Icons.add,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          appBar: AppBar(
            elevation: 0,
            title: TabBar(
              controller: _tabController,
              tabs: [
                const Tab(
                  icon: Icon(Icons.rss_feed),
                ),
                const Tab(
                  icon: Icon(Icons.home),
                ),
                const Tab(
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
