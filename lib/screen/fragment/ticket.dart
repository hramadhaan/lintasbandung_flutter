import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_latihan/model/list_damri.dart';
import 'package:http/http.dart' as http;

class TicketScreen extends StatefulWidget {
  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  List<ListDamri> _damri = [];

  var loading = false;

  Future<void> _getDataDamri() async {
    _damri.clear();
    setState(() {
      loading = true;
    });
    const url = 'https://lintasbandung.nyoobie.com/API/damriAllRoute';
    final response = await http.get(url);
    final responseData = json.decode(response.body);
    responseData.forEach((damri) {
      final db = new ListDamri(
        id: damri['id'],
        nama_trayek: damri['nama_trayek'],
        from: damri['from'],
        to: damri['to'],
        harga: damri['harga'],
      );
      _damri.add(db);
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataDamri();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _getDataDamri,
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _damri.length,
                itemBuilder: (context, i) {
                  final x = _damri[i];
                  return InkWell(
                    onTap: (){},
                    child: ListTile(
                      title: Text(
                        x.nama_trayek,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
