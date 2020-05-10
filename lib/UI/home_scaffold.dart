import 'dart:math';

import 'package:flutter/material.dart';

import './new_task.dart';
import './settings_page.dart';
import './week_view.dart';
import 'intray_page.dart';
import '../global.dart';

class HomeScaffold extends StatefulWidget {
  @override
  _HomeScaffoldState createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold>
    with TickerProviderStateMixin {
  TabController _tabController;
  AnimationController _opacityController;
  AnimationController _opacityController2;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  color: Theme.of(context).accentColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        FadeTransition(
                            opacity: ReverseAnimation(_tabController.animation),
                            child:
                            Text("Week View", style: intrayTitleTextStyle)),
                        FadeTransition(
                            opacity: _opacityController,
                            child: Text("Home", style: intrayTitleTextStyle)),
                        FadeTransition(
                            opacity: _opacityController2,
                            child:
                            Text("User Info", style: intrayTitleTextStyle)),
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
                    backgroundColor: Theme.of(context).accentColor,
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
          labelColor: Theme.of(context).accentColor,
          unselectedLabelColor: Theme.of(context).splashColor,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}