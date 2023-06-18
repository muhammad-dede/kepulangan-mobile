import 'package:kepulangan/app/data/models/cargo.dart';
import 'package:kepulangan/app/data/models/imigran.dart';

class Jenazah {
  int? id;
  Imigran? imigran;
  Cargo? cargo;
  String? fotoJenazah;
  String? fotoPaspor;
  String? fotoBrafaks;

  Jenazah({
    this.id,
    this.imigran,
    this.cargo,
    this.fotoJenazah,
    this.fotoPaspor,
    this.fotoBrafaks,
  });

  Jenazah.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    imigran =
        json['imigran'] != null ? Imigran.fromJson(json['imigran']) : null;
    cargo = json['cargo'] != null ? Cargo.fromJson(json['cargo']) : null;
    fotoJenazah = json['foto_jenazah'];
    fotoPaspor = json['foto_paspor'];
    fotoBrafaks = json['foto_brafaks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (imigran != null) {
      data['imigran'] = imigran!.toJson();
    }
    if (cargo != null) {
      data['cargo'] = cargo!.toJson();
    }
    data['foto_jenazah'] = fotoJenazah;
    data['foto_paspor'] = fotoPaspor;
    data['foto_brafaks'] = fotoBrafaks;
    return data;
  }
}
