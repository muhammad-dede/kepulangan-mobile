class Koordinator {
  int? id;
  String? nama;
  String? nip;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Koordinator({
    this.id,
    this.nama,
    this.nip,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Koordinator.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    nama = json['nama'];
    nip = json['nip'];
    status = int.parse(json['status'].toString());
    createdAt = DateTime.parse(json["created_at"]);
    updatedAt = DateTime.parse(json["updated_at"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    data['nip'] = nip;
    data['status'] = status;
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
    return data;
  }
}
