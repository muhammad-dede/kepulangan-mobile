import 'package:kepulangan/app/data/models/antar_area.dart';
import 'package:kepulangan/app/data/models/layanan.dart';
import 'package:kepulangan/app/data/models/kepulangan.dart';

class Area {
  int? id;
  String? nama;
  AntarArea? antarArea;
  List<Layanan>? layanan;
  List<Kepulangan>? kepulangan;

  Area({
    this.id,
    this.nama,
    this.antarArea,
    this.layanan,
    this.kepulangan,
  });

  Area.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    nama = json['nama'];
    antarArea = json['antar_area'] != null
        ? AntarArea.fromJson(json['antar_area'])
        : null;
    if (json['layanan'] != null) {
      layanan = <Layanan>[];
      json['layanan'].forEach((v) {
        layanan!.add(Layanan.fromJson(v));
      });
    }
    if (json['kepulangan'] != null) {
      kepulangan = <Kepulangan>[];
      json['kepulangan'].forEach((v) {
        kepulangan!.add(Kepulangan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    if (antarArea != null) {
      data['antar_area'] = antarArea!.toJson();
    }
    if (layanan != null) {
      data['layanan'] = layanan!.map((v) => v.toJson()).toList();
    }
    if (kepulangan != null) {
      data['kepulangan'] = kepulangan!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
