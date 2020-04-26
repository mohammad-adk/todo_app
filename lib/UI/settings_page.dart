import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global.dart';
import '../providers/auth.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    return Container(
      color: darkGreyColor,
      padding: EdgeInsets.only(top: 250),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Username: ${user.userName}',
                style: TextStyle(color: Colors.white)),
            Text('FirstName: ${user.firstName}',
                style: TextStyle(color: Colors.white)),
            Text('LastName: ${user.lastName}',
                style: TextStyle(color: Colors.white)),
            FlatButton(
              child: Text('LogOut', style: TextStyle(color: Colors.white)),
              onPressed: user.logout,
            )
          ],
        ),
      ),
    );
  }
}
