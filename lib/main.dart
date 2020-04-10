import 'package:flutter/material.dart';
import 'package:flutter_latihan/screen/login.dart';
import 'package:flutter_latihan/screen/main_screen.dart';
import 'package:flutter_latihan/screen/register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      title: 'Lintas Bandung',
      theme: ThemeData(
        primaryColor: Color(0xff202040),
        accentColor: Color(0xff543864),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        MainScreen.routeName: (ctx) => MainScreen(),
        RegisterScreen.routeName: (ctx) => RegisterScreen(),
      },
    );
  }
}
