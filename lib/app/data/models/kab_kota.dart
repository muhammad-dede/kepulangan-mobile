import 'package:kepulangan/app/data/models/provinsi.dart';

class KabKota {
  int? id;
  String? nama;
  Provinsi? provinsi;

  KabKota({
    this.id,
    this.nama,
    this.provinsi,
  });

  KabKota.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    nama = json['nama'];
    provinsi =
        json['provinsi'] != null ? Provinsi.fromJson(json['provinsi']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    if (provinsi != null) {
      data['provinsi'] = provinsi!.toJson();
    }
    return data;
  }
}
