import 'package:kepulangan/app/data/models/kab_kota.dart';

class Provinsi {
  int? id;
  String? nama;
  List<KabKota>? kabKota;

  Provinsi({
    this.id,
    this.nama,
    this.kabKota,
  });

  Provinsi.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    nama = json['nama'];
    if (json['kab_kota'] != null) {
      kabKota = <KabKota>[];
      json['kab_kota'].forEach((v) {
        kabKota!.add(KabKota.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    if (kabKota != null) {
      data['kab_kota'] = kabKota!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
