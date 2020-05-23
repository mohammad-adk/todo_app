import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/tasks.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import './UI/home_page.dart';
import 'UI/auth_screen.dart';
import './providers/auth.dart';
import './UI/splash_screen.dart';
import './providers/tasks.dart';
import './UI/new_task.dart';
import 'global.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  ThemeData _buildTheme(Brightness brightness) {
    return brightness == Brightness.dark
        ? ThemeData.dark().copyWith(
        primaryColor: darkGreyColor,
        accentColor: Colors.black,
        splashColor: Colors.white)
        : ThemeData.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
          fontFamily: 'Basier',
        ),
        primaryColor: Colors.blueGrey,
        accentColor: Colors.white,
        splashColor: Colors.white,
        
    );
  }


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
        builder: (ctx, auth, _) => DynamicTheme(
          defaultBrightness: Brightness.light,
          data: (brightness) => _buildTheme(brightness),
          themedWidgetBuilder:(context, theme) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Todo App',
            theme: theme,
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
      ),
    );
  }
}
