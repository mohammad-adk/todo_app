
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<Auth>(context);
    final _nameController = TextEditingController(text: _user.firstName);
    final _lastNameController = TextEditingController(text: _user.lastName);
    final _userNameController = TextEditingController(text: _user.userName);
    final _nameFocus = FocusNode();
    final _lastNameFocus = FocusNode();
    final _usernameFocus = FocusNode();
    final _submitData = _user.saveUserInfo;
    return Container(
      color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(top: 250),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('First Name', style: TextStyle(color: Colors.white)),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: null,
                      controller: _nameController,
                      focusNode: _nameFocus,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_usernameFocus),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Text('Last Name', style: TextStyle(color: Colors.white)),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: null,
                      controller: _lastNameController,
                      focusNode: _lastNameFocus,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_usernameFocus),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Text('Username', style: TextStyle(color: Colors.white)),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: null,
                      controller: _userNameController,
                      focusNode: _usernameFocus,
                      onSubmitted: (_) => _submitData(
                          _nameController.value.text,
                          _lastNameController.value.text,
                          _userNameController.value.text),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text('LogOut', style: TextStyle(color: Colors.red)),
                    onPressed: _user.logout,
                  ),
                  FlatButton(
                    child: Text(
                      'Light Mode',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
