import 'dart:io';

import 'package:kepulangan/app/data/models/spu.dart';

class SpuTiket {
  int? id;
  Spu? spu;
  String? fotoTiket;
  File? fotoTiketFile;

  SpuTiket({
    this.id,
    this.spu,
    this.fotoTiket,
    this.fotoTiketFile,
  });

  SpuTiket.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    spu = json['spu'] != null ? Spu.fromJson(json['spu']) : null;
    fotoTiket = json['foto_tiket'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (spu != null) {
      data['spu'] = spu!.toJson();
    }
    data['foto_tiket'] = fotoTiket;

    return data;
  }
}
