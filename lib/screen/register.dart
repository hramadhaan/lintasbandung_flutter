import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String firstName, lastName, email, phone, password;
  final _key = GlobalKey<FormState>();

  void check() {
    final form = this._key.currentState;
    if (form.validate()) {
      form.save();
      register();
    }
  }

  void register() async {
    const url = 'http://lintasbandung.nyoobie.com/API/register';
    final response = await http.post(
      url,
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'password': password
      },
    );
    final responseJson = json.decode(response.body);
    String token = responseJson['status'];

    if (token.contains('gagal')) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Ooops something went wrong !',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text('E-Mail atau Password anda telah terdaftar'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Form(
          key: _key,
          child: ListView(
            children: <Widget>[
              TextFormField(
                onSaved: (x) => firstName = x,
                decoration: InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              TextFormField(
                onSaved: (x) => lastName = x,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
              TextFormField(
                onSaved: (x) => email = x,
                decoration: InputDecoration(
                  labelText: 'E-Mail',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                onSaved: (x) => phone = x,
                decoration: InputDecoration(
                  labelText: 'Phone',
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                onSaved: (x) => password = x,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              RaisedButton(
                child: Text('Register Now'),
                onPressed: check,
              )
            ],
          ),
        ),
      ),
    );
  }
}
