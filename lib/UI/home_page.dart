import 'dart:async';

import 'package:dynamic_theme/dynamic_theme.dart';
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
        duration: Duration(milliseconds: 350),
        animationBehavior: AnimationBehavior.preserve)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  dispose() {
    _slideController.dispose();
    super.dispose();
  }

  ThemeData dark = ThemeData(
      primaryColor: darkGreyColor,
      accentColor: Colors.grey[600],
      splashColor: Colors.white);

  ThemeData light = ThemeData(
      primaryColor: Colors.blueGrey,
      accentColor: Colors.white,
      splashColor: Colors.white);

  void toggleDarkMode() {
    _slideController.forward(from: 0);
    isDark = !isDark;
    DynamicTheme.of(context).setThemeData(isDark ? dark : light) ;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Stack(
          children: <Widget>[
            Theme(data: !isDark ? dark : light, child: HomeScaffold(2)),
            PageReveal(
              revealPercent: _slideController.value,
              child: Theme(data: isDark ? dark : light, child: HomeScaffold(1)),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                focusElevation: 0,
                highlightElevation: 0,
                hoverColor: Colors.transparent,
                hoverElevation: 0,
                focusColor: null,
                onPressed: toggleDarkMode,
                child: Icon(Icons.wb_sunny),
                elevation: 0,
                heroTag: "Tag",
              ),
            ),
          ],
        ));
  }
}
