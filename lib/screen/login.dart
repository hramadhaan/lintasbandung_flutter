import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_latihan/screen/main_screen.dart';
import 'package:flutter_latihan/screen/register.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginScreenState extends State<LoginScreen> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  final _key = GlobalKey<FormState>();

  String email, password;

  void check() {
    final form = this._key.currentState;

    if (form.validate()) {
      form.save();
      login();
    }
  }

  void login() async {
    const url = 'http://lintasbandung.nyoobie.com/API/loginAPI';
    final response = await http.post(
      url,
      body: {
        "email": email,
        "password": password,
      },
    );
    final data = json.decode(response.body);
    String token = data['token'];

    if (token.contains("false")) {
      showDialog(
        context: context,
        builder: (x) => AlertDialog(
          title: Text('Login Gagal'),
          content:
              Text('E-Mail dan Password yang Anda masukkan salah, coba lagi'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () => Navigator.of(x).pop(),
            )
          ],
        ),
      );
    } else {
      print(token);
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(token);
      });
    }
  }

  void savePref(String values) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString("token", values);
      pref.commit();
    });
  }

  var tokens;

  void getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      tokens = preferences.getString("token");
      _loginStatus =
          tokens == "false" ? LoginStatus.notSignIn : LoginStatus.signIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  void signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("token", "false");
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(
            title: Text('Login'),
          ),
          body: Form(
            key: _key,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'E-Mail',
                  ),
                  onSaved: (x) => email = x,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: (p) => password = p,
                ),
                RaisedButton(
                  onPressed: check,
                  child: Text('Login'),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(RegisterScreen.routeName);
                  },
                  child: Text(
                    'Daftar Sekarang',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return MainScreen(
          signOut: signOut,
        );
        break;
    }
  }
}
