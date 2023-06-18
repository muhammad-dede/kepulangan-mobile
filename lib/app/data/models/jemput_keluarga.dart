import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/data/models/kepulangan.dart';
import 'package:kepulangan/app/data/models/user.dart';

class JemputKeluarga {
  int? id;
  Kepulangan? kepulangan;
  Imigran? imigran;
  String? namaPenjemput;
  String? hubunganDenganPmi;
  String? noTelpPenjemput;
  DateTime? tanggalSerahTerima;
  String? fotoPenjemput;
  String? fotoSerahTerima;
  User? user;

  JemputKeluarga({
    this.id,
    this.kepulangan,
    this.imigran,
    this.namaPenjemput,
    this.hubunganDenganPmi,
    this.noTelpPenjemput,
    this.tanggalSerahTerima,
    this.fotoPenjemput,
    this.fotoSerahTerima,
    this.user,
  });

  JemputKeluarga.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    kepulangan = json['kepulangan'] != null
        ? Kepulangan.fromJson(json['kepulangan'])
        : null;
    imigran =
        json['imigran'] != null ? Imigran.fromJson(json['imigran']) : null;
    namaPenjemput = json['nama_penjemput'];
    hubunganDenganPmi = json['hubungan_dengan_pmi'];
    noTelpPenjemput = json['no_telp_penjemput'];
    tanggalSerahTerima = json['tanggal_serah_terima'] != null
        ? DateTime.parse(json['tanggal_serah_terima'].toString())
        : null;
    fotoPenjemput = json['foto_penjemput'];
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
    data['nama_penjemput'] = namaPenjemput;
    data['hubungan_dengan_pmi'] = hubunganDenganPmi;
    data['no_telp_penjemput'] = noTelpPenjemput;
    data['tanggal_serah_terima'] = tanggalSerahTerima?.toIso8601String();
    data['foto_penjemput'] = fotoPenjemput;
    data['foto_serah_terima'] = fotoSerahTerima;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
