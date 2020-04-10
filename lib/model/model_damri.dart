import 'package:flutter/foundation.dart';

class Damri {
  final String id;
  final String nama_trayek;
  final List<String> trayek;
  final String form;
  final String to;
  final String harga;

  Damri({
    @required this.id,
    @required this.nama_trayek,
    @required this.trayek,
    @required this.form,
    @required this.to,
    @required this.harga,
  });
}
