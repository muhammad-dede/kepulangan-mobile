import 'dart:io';

import 'package:kepulangan/app/data/models/bast_darat.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/data/models/kepulangan.dart';

class Darat {
  int? id;
  Kepulangan? kepulangan;
  Imigran? imigran;
  BastDarat? bastDarat;
  String? fotoBast;
  File? fotoBastFile;

  Darat({
    this.id,
    this.kepulangan,
    this.imigran,
    this.bastDarat,
    this.fotoBast,
    this.fotoBastFile,
  });

  Darat.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    kepulangan = json['kepulangan'] != null
        ? Kepulangan.fromJson(json['kepulangan'])
        : null;
    imigran =
        json['imigran'] != null ? Imigran.fromJson(json['imigran']) : null;
    bastDarat = json['bast_darat'] != null
        ? BastDarat.fromJson(json['bast_darat'])
        : null;
    fotoBast = json['foto_bast'];
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
    if (bastDarat != null) {
      data['bast_darat'] = bastDarat!.toJson();
    }
    data['foto_bast'] = fotoBast;
    return data;
  }
}
