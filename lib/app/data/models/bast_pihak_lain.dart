import 'package:kepulangan/app/data/models/jemput_pihak_lain.dart';
import 'package:kepulangan/app/data/models/pihak_kedua.dart';
import 'package:kepulangan/app/data/models/user.dart';

class BastPihakLain {
  int? id;
  PihakKedua? pihakKedua;
  DateTime? tanggalSerahTerima;
  String? fotoPihakKedua;
  String? fotoSerahTerima;
  int? terlaksana;
  User? user;
  List<JemputPihakLain>? jemputPihakLain;

  BastPihakLain({
    this.id,
    this.pihakKedua,
    this.tanggalSerahTerima,
    this.fotoPihakKedua,
    this.fotoSerahTerima,
    this.terlaksana,
    this.user,
    this.jemputPihakLain,
  });

  BastPihakLain.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    pihakKedua = json['pihak_kedua'] != null
        ? PihakKedua.fromJson(json['pihak_kedua'])
        : null;
    tanggalSerahTerima = json["tanggal_serah_terima"] != null
        ? DateTime.parse(json["tanggal_serah_terima"])
        : null;
    fotoPihakKedua = json['foto_pihak_kedua'];
    fotoSerahTerima = json['foto_serah_terima'];
    terlaksana = json['terlaksana'] == null ||
            json['terlaksana'] == 0 ||
            json['terlaksana'] == "0"
        ? 0
        : 1;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['jemput_pihak_lain'] != null) {
      jemputPihakLain = <JemputPihakLain>[];
      json['jemput_pihak_lain'].forEach((v) {
        jemputPihakLain!.add(JemputPihakLain.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (pihakKedua != null) {
      data['pihak_kedua'] = pihakKedua!.toJson();
    }
    data['tanggal_serah_terima'] = tanggalSerahTerima?.toIso8601String();
    data['foto_pihak_kedua'] = fotoPihakKedua;
    data['foto_serah_terima'] = fotoSerahTerima;
    data['terlaksana'] =
        terlaksana != null ? int.parse(terlaksana!.toString()) : null;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (jemputPihakLain != null) {
      data['jemput_pihak_lain'] =
          jemputPihakLain!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
