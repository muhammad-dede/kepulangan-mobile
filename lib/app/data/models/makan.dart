import 'package:kepulangan/app/data/models/bast_makan.dart';
import 'package:kepulangan/app/data/models/imigran.dart';

class Makan {
  int? id;
  Imigran? imigran;
  BastMakan? bastMakan;

  Makan({
    this.id,
    this.imigran,
    this.bastMakan,
  });

  Makan.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    imigran =
        json['imigran'] != null ? Imigran.fromJson(json['imigran']) : null;
    bastMakan = json['bast_makan'] != null
        ? BastMakan.fromJson(json['bast_makan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (imigran != null) {
      data['imigran'] = imigran!.toJson();
    }
    if (bastMakan != null) {
      data['bast_makan'] = bastMakan!.toJson();
    }
    return data;
  }
}
