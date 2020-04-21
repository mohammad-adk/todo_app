import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/tasks.dart';

import './UI/home_page.dart';
import 'UI/auth_screen.dart';
import './providers/auth.dart';
import './UI/splash_screen.dart';
import './providers/tasks.dart';
import './UI/new_task.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth,Tasks>(
          create: (_) => Tasks(),
          update: (_, auth, previousTasks)=>Tasks()..update(auth.token, auth.userId, previousTasks == null ? [] : previousTasks.tasks),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo App',
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          home: auth.isAuth
              ? MyHomePage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            MyHomePage.routeName: (ctx) => MyHomePage(),
            NewTask.routeName:(ctx) => NewTask(),
          },
        ),
      ),
    );
  }
}
