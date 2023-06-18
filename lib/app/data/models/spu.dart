import 'package:kepulangan/app/data/models/bast_udara.dart';
import 'package:kepulangan/app/data/models/provinsi.dart';
import 'package:kepulangan/app/data/models/spu_tiket.dart';

class Spu {
  int? id;
  BastUdara? bastUdara;
  String? noSurat;
  DateTime? tanggalSurat;
  Provinsi? provinsi;
  String? noPesawat;
  String? jamPesawat;
  DateTime? tanggalPesawat;
  List<SpuTiket>? spuTiket;

  Spu({
    this.id,
    this.bastUdara,
    this.noSurat,
    this.tanggalSurat,
    this.provinsi,
    this.noPesawat,
    this.jamPesawat,
    this.tanggalPesawat,
    this.spuTiket,
  });

  Spu.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    bastUdara = json['bast_udara'] != null
        ? BastUdara.fromJson(json['bast_udara'])
        : null;
    noSurat = json['no_surat'];
    tanggalSurat = json["tanggal_surat"] != null
        ? DateTime.parse(json["tanggal_surat"])
        : null;
    provinsi =
        json['provinsi'] != null ? Provinsi.fromJson(json['provinsi']) : null;
    noPesawat = json['no_pesawat'];
    jamPesawat = json['jam_pesawat'];
    tanggalPesawat = json["tanggal_pesawat"] != null
        ? DateTime.parse(json["tanggal_pesawat"])
        : null;
    if (json['spu_tiket'] != null) {
      spuTiket = <SpuTiket>[];
      json['spu_tiket'].forEach((v) {
        spuTiket!.add(SpuTiket.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (bastUdara != null) {
      data['penyedia_jasa'] = bastUdara!.toJson();
    }
    data['no_surat'] = noSurat;
    data['tanggal_surat'] = tanggalSurat?.toIso8601String();
    if (provinsi != null) {
      data['provinsi'] = provinsi!.toJson();
    }
    data['no_pesawat'] = noPesawat;
    data['jam_pesawat'] = jamPesawat;
    data['tanggal_pesawat'] = tanggalPesawat?.toIso8601String();
    if (spuTiket != null) {
      data['spu_tiket'] = spuTiket!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
