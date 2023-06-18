import 'package:kepulangan/app/data/models/kawasan.dart';
import 'package:kepulangan/app/data/models/negara.dart';

class SubKawasan {
  int? id;
  String? nama;
  Kawasan? kawasan;
  List<Negara>? negara;

  SubKawasan({
    this.id,
    this.nama,
    this.kawasan,
    this.negara,
  });

  SubKawasan.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    nama = json['nama'];
    kawasan =
        json['kawasan'] != null ? Kawasan.fromJson(json['kawasan']) : null;
    if (json['negara'] != null) {
      negara = <Negara>[];
      json['negara'].forEach((v) {
        negara!.add(Negara.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    if (kawasan != null) {
      data['kawasan'] = kawasan!.toJson();
    }
    if (negara != null) {
      data['negara'] = negara!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
