import 'package:kepulangan/app/data/models/group.dart';

class User {
  int? id;
  String? nama;
  String? noIdentitas;
  String? jabatan;
  Group? group;
  String? telepon;
  String? avatar;
  String? qrCode;
  String? email;
  String? role;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.nama,
    this.noIdentitas,
    this.jabatan,
    this.group,
    this.telepon,
    this.avatar,
    this.qrCode,
    this.email,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    nama = json['nama'];
    noIdentitas = json['no_identitas'];
    jabatan = json['jabatan'];
    group = json['group'] != null ? Group.fromJson(json['group']) : null;
    telepon = json['telepon'];
    avatar = json['avatar'];
    qrCode = json['qr_code'];
    email = json['email'];
    role = json['role'];
    createdAt = DateTime.parse(json["created_at"]);
    updatedAt = DateTime.parse(json["updated_at"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    data['no_identitas'] = noIdentitas;
    data['jabatan'] = jabatan;
    if (group != null) {
      data['group'] = group!.toJson();
    }
    data['telepon'] = telepon;
    data['avatar'] = avatar;
    data['qr_code'] = qrCode;
    data['email'] = email;
    data['role'] = role;
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
    return data;
  }
}
