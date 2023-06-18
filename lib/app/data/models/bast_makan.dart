import 'package:kepulangan/app/data/models/alamat.dart';
import 'package:kepulangan/app/data/models/makan.dart';
import 'package:kepulangan/app/data/models/penyedia_jasa.dart';
import 'package:kepulangan/app/data/models/user.dart';

class BastMakan {
  int? id;
  String? purchaseOrder;
  PenyediaJasa? penyediaJasa;
  Alamat? alamat;
  int? durasiPengerjaan;
  DateTime? tanggalSerahTerima;
  String? waktuSerahTerima;
  String? fotoPenyediaJasa;
  String? fotoSerahTerima;
  String? fotoInvoice;
  int? terlaksana;
  User? user;
  List<Makan>? makan;

  BastMakan({
    this.id,
    this.purchaseOrder,
    this.penyediaJasa,
    this.alamat,
    this.durasiPengerjaan,
    this.tanggalSerahTerima,
    this.waktuSerahTerima,
    this.fotoPenyediaJasa,
    this.fotoSerahTerima,
    this.fotoInvoice,
    this.terlaksana,
    this.user,
    this.makan,
  });

  BastMakan.fromJson(Map<String, dynamic> json) {
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
    waktuSerahTerima = json['waktu_serah_terima'];
    fotoPenyediaJasa = json['foto_penyedia_jasa'];
    fotoSerahTerima = json['foto_serah_terima'];
    fotoInvoice = json['foto_invoice'];
    terlaksana = json['terlaksana'] == null || json['terlaksana'] == 0 ? 0 : 1;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['makan'] != null) {
      makan = <Makan>[];
      json['makan'].forEach((v) {
        makan!.add(Makan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (penyediaJasa != null) {
      data['penyedia_jasa'] = penyediaJasa!.toJson();
    }
    data['tanggal_serah_terima'] = tanggalSerahTerima?.toIso8601String();
    data['waktu_serah_terima'] = waktuSerahTerima;
    data['foto_penyedia_jasa'] = fotoPenyediaJasa;
    data['foto_serah_terima'] = fotoSerahTerima;
    data['foto_invoice'] = fotoInvoice;
    data['terlaksana'] =
        terlaksana != null ? int.parse(terlaksana!.toString()) : null;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (makan != null) {
      data['makan'] = makan!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
