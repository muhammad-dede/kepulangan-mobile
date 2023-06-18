import 'package:kepulangan/app/data/models/bast_pihak_lain.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/data/models/kepulangan.dart';

class JemputPihakLain {
  int? id;
  Kepulangan? kepulangan;
  Imigran? imigran;
  BastPihakLain? bastPihakLain;

  JemputPihakLain({
    this.id,
    this.kepulangan,
    this.imigran,
    this.bastPihakLain,
  });

  JemputPihakLain.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    kepulangan = json['kepulangan'] != null
        ? Kepulangan.fromJson(json['kepulangan'])
        : null;
    imigran =
        json['imigran'] != null ? Imigran.fromJson(json['imigran']) : null;
    bastPihakLain = json['bast_pihak_lain'] != null
        ? BastPihakLain.fromJson(json['bast_pihak_lain'])
        : null;
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
    if (bastPihakLain != null) {
      data['bast_pihak_lain'] = bastPihakLain!.toJson();
    }
    return data;
  }
}
