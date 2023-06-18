class JenisKelamin {
  int? id;
  String? nama;

  JenisKelamin({
    this.id,
    this.nama,
  });

  JenisKelamin.fromJson(Map<String, dynamic> json) {
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
