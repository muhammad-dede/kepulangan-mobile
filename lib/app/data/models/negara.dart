import 'package:kepulangan/app/data/models/sub_kawasan.dart';

class Negara {
  int? id;
  String? nama;
  String? namaLengkap;
  SubKawasan? subKawasan;

  Negara({
    this.id,
    this.nama,
    this.namaLengkap,
    this.subKawasan,
  });

  Negara.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    nama = json['nama'];
    namaLengkap = json['nama_lengkap'];
    subKawasan = json['sub_kawasan'] != null
        ? SubKawasan.fromJson(json['sub_kawasan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    data['nama_lengkap'] = namaLengkap;
    if (subKawasan != null) {
      data['sub_kawasan'] = subKawasan!.toJson();
    }
    return data;
  }
}
