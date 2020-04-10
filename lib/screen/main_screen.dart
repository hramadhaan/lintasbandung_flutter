import 'dart:convert';
import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_latihan/screen/fragment/angkot.dart';
import 'package:flutter_latihan/screen/fragment/profile.dart';
import 'package:flutter_latihan/screen/fragment/ticket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  final VoidCallback signOut;
  MainScreen({this.signOut});

  static const routeName = '/main';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  var tokens;

  String name = "";

  void decode(String token) async {
    const url = 'https://lintasbandung.nyoobie.com/API/decode';
    final response = await http.post(url, headers: {
      HttpHeaders.authorizationHeader: '$token',
    });
    final responseJson = json.decode(response.body);
    setState(() {
      name = "${responseJson['first_name']} ${responseJson['last_name']}";
    });

    print(responseJson);
  }

  void getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      tokens = pref.getString("token");
      decode(tokens);
      // print(tokens);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  void signOut() {
    setState(() {
      widget.signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _listPage = <Widget>[
      AngkotScreen(),
      TicketScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Lintas Bandung'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (x) {
              setState(() {
                if (x == 1) {
                  signOut();
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Logout'),
                value: 1,
              )
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        containerHeight: 56,
        iconSize: 18,
        itemCornerRadius: 10,
        curve: Curves.easeInOutQuart,
        onItemSelected: _onNavBarTapped,
        items: [
          BottomNavyBarItem(
            icon: Icon(Feather.truck),
            title: Text('Angkot'),
            activeColor: Theme.of(context).accentColor,
            inactiveColor: Colors.deepPurple[100],
          ),
          BottomNavyBarItem(
            icon: Icon(Feather.shopping_cart),
            title: Text('Tiket'),
            activeColor: Theme.of(context).accentColor,
            inactiveColor: Colors.deepPurple[100],
          ),
          BottomNavyBarItem(
            icon: Icon(Feather.user),
            title: Text('Profile'),
            activeColor: Theme.of(context).accentColor,
            inactiveColor: Colors.deepPurple[100],
          ),
        ],
      ),
      body: _listPage[_currentIndex],
    );
  }
}
