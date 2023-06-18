import 'package:kepulangan/app/data/models/area.dart';
import 'package:kepulangan/app/data/models/darat.dart';
import 'package:kepulangan/app/data/models/jabatan.dart';
import 'package:kepulangan/app/data/models/jemput_keluarga.dart';
import 'package:kepulangan/app/data/models/jemput_pihak_lain.dart';
import 'package:kepulangan/app/data/models/jenazah.dart';
import 'package:kepulangan/app/data/models/jenis_kelamin.dart';
import 'package:kepulangan/app/data/models/kab_kota.dart';
import 'package:kepulangan/app/data/models/kawasan.dart';
import 'package:kepulangan/app/data/models/kepulangan.dart';
import 'package:kepulangan/app/data/models/layanan.dart';
import 'package:kepulangan/app/data/models/makan.dart';
import 'package:kepulangan/app/data/models/negara.dart';
import 'package:kepulangan/app/data/models/pmi.dart';
import 'package:kepulangan/app/data/models/provinsi.dart';
import 'package:kepulangan/app/data/models/pulang_mandiri.dart';
import 'package:kepulangan/app/data/models/rujuk_rs_polri.dart';
import 'package:kepulangan/app/data/models/sub_kawasan.dart';
import 'package:kepulangan/app/data/models/udara.dart';
import 'package:kepulangan/app/data/models/user.dart';

class Imigran {
  int? id;
  String? brafaks;
  String? paspor;
  String? nama;
  JenisKelamin? jenisKelamin;
  Negara? negara;
  SubKawasan? subKawasan;
  Kawasan? kawasan;
  String? alamat;
  KabKota? kabKota;
  Provinsi? provinsi;
  String? noTelp;
  Jabatan? jabatan;
  DateTime? tanggalKedatangan;
  Area? area;
  Layanan? layanan;
  Kepulangan? kepulangan;
  int? terlaksana;
  User? user;
  Pmi? pmi;
  Jenazah? jenazah;
  Darat? darat;
  Udara? udara;
  RujukRsPolri? rujukRsPolri;
  PulangMandiri? pulangMandiri;
  JemputKeluarga? jemputKeluarga;
  JemputPihakLain? jemputPihakLain;
  List<Makan>? makan;

  Imigran({
    this.id,
    this.brafaks,
    this.paspor,
    this.nama,
    this.jenisKelamin,
    this.negara,
    this.subKawasan,
    this.kawasan,
    this.alamat,
    this.kabKota,
    this.provinsi,
    this.noTelp,
    this.jabatan,
    this.tanggalKedatangan,
    this.area,
    this.layanan,
    this.kepulangan,
    this.terlaksana,
    this.user,
    this.pmi,
    this.jenazah,
    this.darat,
    this.udara,
    this.rujukRsPolri,
    this.pulangMandiri,
    this.jemputKeluarga,
    this.jemputPihakLain,
    this.makan,
  });

  Imigran.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    brafaks = json['brafaks'];
    paspor = json['paspor'];
    nama = json['nama'];
    jenisKelamin = json['jenis_kelamin'] != null
        ? JenisKelamin.fromJson(json['jenis_kelamin'])
        : null;
    negara = json['negara'] != null ? Negara.fromJson(json['negara']) : null;
    subKawasan = json['sub_kawasan'] != null
        ? SubKawasan.fromJson(json['sub_kawasan'])
        : null;
    kawasan =
        json['kawasan'] != null ? Kawasan.fromJson(json['kawasan']) : null;
    alamat = json['alamat'];
    kabKota =
        json['kab_kota'] != null ? KabKota.fromJson(json['kab_kota']) : null;
    provinsi =
        json['provinsi'] != null ? Provinsi.fromJson(json['provinsi']) : null;
    noTelp = json['no_telp'];
    jabatan =
        json['jabatan'] != null ? Jabatan.fromJson(json['jabatan']) : null;
    tanggalKedatangan = json["tanggal_kedatangan"] != null
        ? DateTime.parse(json["tanggal_kedatangan"])
        : null;
    area = json['area'] != null ? Area.fromJson(json['area']) : null;
    layanan =
        json['layanan'] != null ? Layanan.fromJson(json['layanan']) : null;
    kepulangan = json['kepulangan'] != null
        ? Kepulangan.fromJson(json['kepulangan'])
        : null;
    terlaksana = json['terlaksana'] == null || json['terlaksana'] == 0 ? 0 : 1;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    pmi = json['pmi'] != null ? Pmi.fromJson(json['pmi']) : null;
    jenazah =
        json['jenazah'] != null ? Jenazah.fromJson(json['jenazah']) : null;
    udara = json['udara'] != null ? Udara.fromJson(json['udara']) : null;
    darat = json['darat'] != null ? Darat.fromJson(json['darat']) : null;
    rujukRsPolri = json['rujuk_rs_polri'] != null
        ? RujukRsPolri.fromJson(json['rujuk_rs_polri'])
        : null;
    pulangMandiri = json['pulang_mandiri'] != null
        ? PulangMandiri.fromJson(json['pulang_mandiri'])
        : null;
    jemputKeluarga = json['jemput_keluarga'] != null
        ? JemputKeluarga.fromJson(json['jemput_keluarga'])
        : null;
    jemputPihakLain = json['jemput_pihak_lain'] != null
        ? JemputPihakLain.fromJson(json['jemput_pihak_lain'])
        : null;
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
    data['brafaks'] = brafaks;
    data['paspor'] = paspor;
    data['nama'] = nama;
    if (jenisKelamin != null) {
      data['jenis_kelamin'] = jenisKelamin!.toJson();
    }
    if (negara != null) {
      data['negara'] = negara!.toJson();
    }
    if (subKawasan != null) {
      data['sub_kawasan'] = subKawasan!.toJson();
    }
    if (kawasan != null) {
      data['kawasan'] = kawasan!.toJson();
    }
    data['alamat'] = alamat;
    if (kabKota != null) {
      data['kab_kota'] = kabKota!.toJson();
    }
    if (provinsi != null) {
      data['provinsi'] = provinsi!.toJson();
    }
    data['no_telp'] = noTelp;
    if (jabatan != null) {
      data['jabatan'] = jabatan!.toJson();
    }
    data['tanggal_kedatangan'] = tanggalKedatangan?.toIso8601String();
    if (area != null) {
      data['area'] = area!.toJson();
    }
    if (layanan != null) {
      data['layanan'] = layanan!.toJson();
    }
    if (kepulangan != null) {
      data['kepulangan'] = kepulangan!.toJson();
    }
    data['terlaksana'] = terlaksana;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (pmi != null) {
      data['pmi'] = pmi!.toJson();
    }
    if (jenazah != null) {
      data['jenazah'] = jenazah!.toJson();
    }
    if (udara != null) {
      data['udara'] = udara!.toJson();
    }
    if (darat != null) {
      data['darat'] = darat!.toJson();
    }
    if (rujukRsPolri != null) {
      data['rujuk_rs_polri'] = rujukRsPolri!.toJson();
    }
    if (pulangMandiri != null) {
      data['pulang_mandiri'] = pulangMandiri!.toJson();
    }
    if (jemputKeluarga != null) {
      data['jemput_keluarga'] = jemputKeluarga!.toJson();
    }
    if (jemputPihakLain != null) {
      data['jemput_pihak_lain'] = jemputPihakLain!.toJson();
    }
    if (makan != null) {
      data['makan'] = makan!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
