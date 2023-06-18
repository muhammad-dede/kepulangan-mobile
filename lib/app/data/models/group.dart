import 'package:kepulangan/app/data/models/layanan.dart';

class Group {
  int? id;
  String? nama;
  List<Layanan>? layanan;

  Group({this.id, this.nama, this.layanan});

  Group.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    nama = json['nama'];
    if (json['layanan'] != null) {
      layanan = <Layanan>[];
      json['layanan'].forEach((v) {
        layanan!.add(Layanan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    if (layanan != null) {
      data['layanan'] = layanan!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
