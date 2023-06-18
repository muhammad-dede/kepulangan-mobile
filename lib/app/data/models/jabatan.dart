class Jabatan {
  int? id;
  String? nama;

  Jabatan({
    this.id,
    this.nama,
  });

  Jabatan.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    nama = json['nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    return data;
  }
}
