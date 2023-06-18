import 'package:kepulangan/app/data/models/area.dart';
import 'package:kepulangan/app/data/models/cargo.dart';
import 'package:kepulangan/app/data/models/group.dart';
import 'package:kepulangan/app/data/models/kepulangan.dart';
import 'package:kepulangan/app/data/models/masalah.dart';

class Layanan {
  int? id;
  String? nama;
  List<Area>? area;
  List<Group>? group;
  List<Masalah>? masalah;
  List<Kepulangan>? kepulangan;
  List<Cargo>? cargo;

  Layanan({
    this.id,
    this.nama,
    this.area,
    this.group,
    this.masalah,
    this.kepulangan,
    this.cargo,
  });

  Layanan.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    nama = json['nama'];
    if (json['area'] != null) {
      area = <Area>[];
      json['area'].forEach((v) {
        area!.add(Area.fromJson(v));
      });
    }
    if (json['group'] != null) {
      group = <Group>[];
      json['group'].forEach((v) {
        group!.add(Group.fromJson(v));
      });
    }
    if (json['masalah'] != null) {
      masalah = <Masalah>[];
      json['masalah'].forEach((v) {
        masalah!.add(Masalah.fromJson(v));
      });
    }
    if (json['kepulangan'] != null) {
      kepulangan = <Kepulangan>[];
      json['kepulangan'].forEach((v) {
        kepulangan!.add(Kepulangan.fromJson(v));
      });
    }
    if (json['cargo'] != null) {
      cargo = <Cargo>[];
      json['cargo'].forEach((v) {
        cargo!.add(Cargo.fromJson(v));
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
    if (group != null) {
      data['group'] = group!.map((v) => v.toJson()).toList();
    }
    if (masalah != null) {
      data['masalah'] = masalah!.map((v) => v.toJson()).toList();
    }
    if (kepulangan != null) {
      data['kepulangan'] = kepulangan!.map((v) => v.toJson()).toList();
    }
    if (cargo != null) {
      data['cargo'] = cargo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
