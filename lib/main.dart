import 'package:flutter/material.dart';
import 'package:todo_app/models/global.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Todo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.yellow,
      home: SafeArea(top: true,
        child: DefaultTabController(
        length: 3,
        child: new Scaffold(
          body: Stack(children: <Widget>[
              TabBarView(
              children: [
                new Container(
                  color: darkGreyColor,
                ),
                new Container(color: Colors.blueGrey,),
                new Container(
                  color: Colors.lightBlue,
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 50),
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60)
                ),
                color: Colors.white
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Intray",style: intrayTitleTextStyle),
                    Container()
                  ],
                ),
            ),
            Container(margin: EdgeInsets.only(top : 120,left: (MediaQuery.of(context).size.width)/2 - 40),
            width: 80,
            height: 80,
              child: FloatingActionButton(
                backgroundColor: redColor,
                onPressed: (){},
                child: Icon(Icons.add , size: 50,),
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
