import 'package:kepulangan/app/data/models/alamat.dart';
import 'package:kepulangan/app/data/models/penyedia_jasa.dart';
import 'package:kepulangan/app/data/models/spu.dart';
import 'package:kepulangan/app/data/models/udara.dart';
import 'package:kepulangan/app/data/models/user.dart';

class BastUdara {
  int? id;
  String? purchaseOrder;
  PenyediaJasa? penyediaJasa;
  Alamat? alamat;
  int? durasiPengerjaan;
  DateTime? tanggalSerahTerima;
  String? fotoPenyediaJasa;
  String? fotoSerahTerima;
  int? terlaksana;
  User? user;
  List<Udara>? udara;
  Spu? spu;

  BastUdara({
    this.id,
    this.purchaseOrder,
    this.penyediaJasa,
    this.alamat,
    this.durasiPengerjaan,
    this.tanggalSerahTerima,
    this.fotoPenyediaJasa,
    this.fotoSerahTerima,
    this.terlaksana,
    this.user,
    this.udara,
    this.spu,
  });

  BastUdara.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    purchaseOrder = json['purchase_order'];
    penyediaJasa = json['penyedia_jasa'] != null
        ? PenyediaJasa.fromJson(json['penyedia_jasa'])
        : null;
    alamat = json['alamat'] != null ? Alamat.fromJson(json['alamat']) : null;
    durasiPengerjaan = json['durasi_pengerjaan'] != null
        ? int.parse(json['durasi_pengerjaan'].toString())
        : null;
    tanggalSerahTerima = json["tanggal_serah_terima"] != null
        ? DateTime.parse(json["tanggal_serah_terima"])
        : null;
    fotoPenyediaJasa = json['foto_penyedia_jasa'];
    fotoSerahTerima = json['foto_serah_terima'];
    terlaksana = json['terlaksana'] == null ||
            json['terlaksana'] == 0 ||
            json['terlaksana'] == "0"
        ? 0
        : 1;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['udara'] != null) {
      udara = <Udara>[];
      json['udara'].forEach((v) {
        udara!.add(Udara.fromJson(v));
      });
    }
    spu = json['spu'] != null ? Spu.fromJson(json['spu']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (penyediaJasa != null) {
      data['penyedia_jasa'] = penyediaJasa!.toJson();
    }
    data['tanggal_serah_terima'] = tanggalSerahTerima?.toIso8601String();
    data['foto_penyedia_jasa'] = fotoPenyediaJasa;
    data['foto_serah_terima'] = fotoSerahTerima;
    data['terlaksana'] =
        terlaksana != null ? int.parse(terlaksana!.toString()) : null;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (udara != null) {
      data['udara'] = udara!.map((v) => v.toJson()).toList();
    }
    if (spu != null) {
      data['spu'] = spu!.toJson();
    }
    return data;
  }
}
