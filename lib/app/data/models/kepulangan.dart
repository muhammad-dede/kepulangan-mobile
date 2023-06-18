import 'package:kepulangan/app/data/models/area.dart';
import 'package:kepulangan/app/data/models/layanan.dart';

class Kepulangan {
  int? id;
  String? nama;
  List<Area>? area;
  List<Layanan>? layanan;

  Kepulangan({
    this.id,
    this.nama,
    this.area,
    this.layanan,
  });

  Kepulangan.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    nama = json['nama'];
    if (json['area'] != null) {
      area = <Area>[];
      json['area'].forEach((v) {
        area!.add(Area.fromJson(v));
      });
    }
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
    if (area != null) {
      data['area'] = area!.map((v) => v.toJson()).toList();
    }
    if (layanan != null) {
      data['layanan'] = layanan!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
