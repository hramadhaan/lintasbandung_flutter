import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class Angkot {
  final String id;
  final String name;
  final String warna;
  final String kode;
  final String img;
  final String jarak;
  final String tarif;

  Angkot({
    @required this.id,
    @required this.name,
    @required this.warna,
    @required this.kode,
    @required this.img,
    @required this.jarak,
    @required this.tarif,
  });
}

class AngkotProvider with ChangeNotifier {
  List<Angkot> _items = [];

  List<Angkot> get items {
    return [..._items];
  }

  Future<void> fetchProduct() async {
    const url = 'https://lintasbandung.nyoobie.com/API/allVenichle';
    final response = await http.get(url);

    final convertData = json.decode(response.body) as Map<String, dynamic>;
    final List<Angkot> newData = [];

    if (convertData == null) {
      return;
    }
    convertData.forEach((key, value) {
      newData.add(Angkot(
        id: key,
        name: value['name'],
        warna: value['warna'],
        kode: value['kode'],
        img: value['img'],
        jarak: value['jarak'],
        tarif: value['tarif'],
      ));
    });
    _items = newData;
    notifyListeners();
  }
}
