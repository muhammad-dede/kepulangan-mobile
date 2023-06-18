import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/data/models/kepulangan.dart';
import 'package:kepulangan/app/data/models/pihak_kedua.dart';
import 'package:kepulangan/app/data/models/user.dart';

class RujukRsPolri {
  int? id;
  Kepulangan? kepulangan;
  Imigran? imigran;
  PihakKedua? pihakKedua;
  DateTime? tanggalSerahTerima;
  String? fotoPihakKedua;
  String? fotoSerahTerima;
  User? user;

  RujukRsPolri({
    this.id,
    this.kepulangan,
    this.imigran,
    this.pihakKedua,
    this.tanggalSerahTerima,
    this.fotoPihakKedua,
    this.fotoSerahTerima,
    this.user,
  });

  RujukRsPolri.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    kepulangan = json['kepulangan'] != null
        ? Kepulangan.fromJson(json['kepulangan'])
        : null;
    imigran =
        json['imigran'] != null ? Imigran.fromJson(json['imigran']) : null;
    pihakKedua = json['pihak_kedua'] != null
        ? PihakKedua.fromJson(json['pihak_kedua'])
        : null;
    tanggalSerahTerima = json['tanggal_serah_terima'] != null
        ? DateTime.parse(json['tanggal_serah_terima'].toString())
        : null;
    fotoPihakKedua = json['foto_pihak_kedua'];
    fotoSerahTerima = json['foto_serah_terima'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (kepulangan != null) {
      data['kepulangan'] = kepulangan!.toJson();
    }
    if (imigran != null) {
      data['imigran'] = imigran!.toJson();
    }
    if (pihakKedua != null) {
      data['pihak_kedua'] = pihakKedua!.toJson();
    }
    data['tanggal_serah_terima'] = tanggalSerahTerima?.toIso8601String();
    data['foto_pihak_kedua'] = fotoPihakKedua;
    data['foto_serah_terima'] = fotoSerahTerima;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
