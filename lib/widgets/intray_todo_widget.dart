import 'package:flutter/material.dart';
import '../global.dart';


class IntrayTodo extends StatelessWidget{
  final String title;
  IntrayTodo({this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15, left: 15, right: 15),
      padding: EdgeInsets.all(10),
      height: 100,
      width: 100,
      decoration: BoxDecoration(
      color: redColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          new BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 5,
          )
        ]
      ),
      child: Row(
        children: <Widget>[
          Radio(

          ),
          Column(
            children: <Widget>[
              Text(title, style: darkTodoTitle,)
            ],
          )
        ],
      ),
    );
  }

}