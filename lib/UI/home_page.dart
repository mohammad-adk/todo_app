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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.yellow,
      home: SafeArea(
        top: true,
        child: DefaultTabController(
          length: 3,
          child: new Scaffold(
            body: Stack(
              children: <Widget>[
                TabBarView(
                  children: [
                    IntrayPage(),
                    new Container(
                      color: Colors.blueGrey,
                    ),
                    SettingsPage(),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 50),
                  height: 160,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60)),
                      color: Colors.white),
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
                      top: 120,
                      left: (MediaQuery.of(context).size.width) / 2 - 40),
                  width: 80,
                  height: 80,
                  child: FloatingActionButton(
                    backgroundColor: Colors.red,
                    onPressed: () =>
                        Navigator.pushNamed(context, NewTask.routeName),
                    child: Icon(
                      Icons.add,
                      size: 50,
                    ),
                  ),
                )
              ],
            ),
            appBar: AppBar(
              elevation: 0,
              title: new TabBar(
                tabs: [
                  Tab(
                    icon: new Icon(Icons.home),
                  ),
                  Tab(
                    icon: new Icon(Icons.rss_feed),
                  ),
                  Tab(
                    icon: new Icon(Icons.perm_identity),
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
      ),
    );
  }
}
