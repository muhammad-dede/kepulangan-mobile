import 'package:kepulangan/app/data/models/group.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/data/models/masalah.dart';

class Pmi {
  int? id;
  Imigran? imigran;
  Group? group;
  Masalah? masalah;
  String? fotoPmi;
  String? fotoPaspor;

  Pmi({
    this.id,
    this.imigran,
    this.group,
    this.masalah,
    this.fotoPmi,
    this.fotoPaspor,
  });

  Pmi.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    imigran =
        json['imigran'] != null ? Imigran.fromJson(json['imigran']) : null;
    group = json['group'] != null ? Group.fromJson(json['group']) : null;
    masalah =
        json['masalah'] != null ? Masalah.fromJson(json['masalah']) : null;
    fotoPmi = json['foto_pmi'];
    fotoPaspor = json['foto_paspor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (imigran != null) {
      data['imigran'] = imigran!.toJson();
    }
    if (group != null) {
      data['group'] = group!.toJson();
    }
    if (masalah != null) {
      data['masalah'] = masalah!.toJson();
    }
    data['foto_pmi'] = fotoPmi;
    data['foto_paspor'] = fotoPaspor;
    return data;
  }
}
