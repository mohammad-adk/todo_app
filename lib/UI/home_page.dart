import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/widgets/page_reveal.dart';

import '../global.dart';
import './home_scaffold.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.color}) : super(key: key);
  static const routeName = '/homaPage';
  final String title;
  final Color color;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController _slideController;
  bool isDark = false;

  initState() {
    _slideController = AnimationController(
      vsync: this,
      value: 1,
      duration: Duration(milliseconds: 700),
    )
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  ThemeData dark = ThemeData(
      primaryColor: darkGreyColor,
      accentColor: redColor,
      splashColor: Colors.white);

  ThemeData light = ThemeData(
      primaryColor: Colors.blueGrey,
      accentColor: redColor,
      splashColor: Colors.white);

  void toggleDarkMode() {
    _slideController.forward(from: 0);
    Timer(
        Duration(milliseconds: 700),
            () {
          isDark = !isDark;
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Stack(
          children: <Widget>[
            Theme(data: isDark ? light : dark, child: HomeScaffold()),
            PageReveal(
              revealPercent: _slideController.value,
              child:
              Theme(data: isDark ? light : dark, child: HomeScaffold()),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                onPressed: toggleDarkMode,
                child: Icon(Icons.wb_sunny),
                elevation: 0,
              ),
            ),
          ],
        )
    );
  }
}


