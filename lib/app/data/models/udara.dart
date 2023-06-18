import 'dart:io';

import 'package:kepulangan/app/data/models/bast_udara.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/data/models/kepulangan.dart';

class Udara {
  int? id;
  Kepulangan? kepulangan;
  Imigran? imigran;
  BastUdara? bastUdara;
  String? fotoBoardingPass;
  File? fotoBoardingPassFile;

  Udara({
    this.id,
    this.kepulangan,
    this.imigran,
    this.bastUdara,
    this.fotoBoardingPass,
    this.fotoBoardingPassFile,
  });

  Udara.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    kepulangan = json['kepulangan'] != null
        ? Kepulangan.fromJson(json['kepulangan'])
        : null;
    imigran =
        json['imigran'] != null ? Imigran.fromJson(json['imigran']) : null;
    bastUdara = json['bast_udara'] != null
        ? BastUdara.fromJson(json['bast_udara'])
        : null;
    fotoBoardingPass = json['foto_boarding_pass'];
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
    if (bastUdara != null) {
      data['bast_udara'] = bastUdara!.toJson();
    }
    data['foto_boarding_pass'] = fotoBoardingPass;
    return data;
  }
}
