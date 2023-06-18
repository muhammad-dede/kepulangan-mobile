import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/data/models/kepulangan.dart';
import 'package:kepulangan/app/data/models/user.dart';

class PulangMandiri {
  int? id;
  Kepulangan? kepulangan;
  Imigran? imigran;
  String? tanggalSerahTerima;
  String? fotoSerahTerima;
  User? user;

  PulangMandiri({
    this.id,
    this.kepulangan,
    this.imigran,
    this.tanggalSerahTerima,
    this.fotoSerahTerima,
    this.user,
  });

  PulangMandiri.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    kepulangan = json['kepulangan'] != null
        ? Kepulangan.fromJson(json['kepulangan'])
        : null;
    imigran =
        json['imigran'] != null ? Imigran.fromJson(json['imigran']) : null;
    tanggalSerahTerima = json['tanggal_serah_terima'];
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
    data['tanggal_serah_terima'] = tanggalSerahTerima;
    data['foto_serah_terima'] = fotoSerahTerima;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
