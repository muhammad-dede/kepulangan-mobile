import 'package:kepulangan/app/data/models/sub_kawasan.dart';

class Kawasan {
  int? id;
  String? nama;
  List<SubKawasan>? subKawasan;

  Kawasan({
    this.id,
    this.nama,
    this.subKawasan,
  });

  Kawasan.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    nama = json['nama'];
    if (json['sub_kawasan'] != null) {
      subKawasan = <SubKawasan>[];
      json['sub_kawasan'].forEach((v) {
        subKawasan!.add(SubKawasan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    if (subKawasan != null) {
      data['sub_kawasan'] = subKawasan!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
