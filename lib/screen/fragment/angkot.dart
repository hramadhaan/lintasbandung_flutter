import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_latihan/model/model_angkot.dart';
import 'package:http/http.dart' as http;

class AngkotScreen extends StatefulWidget {
  final String text;
  AngkotScreen({this.text});

  @override
  _AngkotScreenState createState() => _AngkotScreenState();
}

class _AngkotScreenState extends State<AngkotScreen> {
  final list = new List<Angkot>();
  var loading = false;

  Future _dataAngkot() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response =
        await http.get('https://lintasbandung.nyoobie.com/API/allVenichle');

    final data = jsonDecode(response.body);
    data.forEach((api) {
      final db = new Angkot(
        id: api['id'],
        name: api['name'],
        warna: api['kode'],
        img: api['img'],
        jarak: api['jarak'],
        tarif: api['tarif'],
      );
      list.add(db);
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataAngkot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Theme.of(context).accentColor,
        onRefresh: _dataAngkot,
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: Text('Percobaan'),
                                content: Text('Anda memilih ${x.name}'),
                              ));
                    },
                    child: ListTile(
                      title: Text(x.name),
                      leading: Icon(Icons.directions_bus),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
