class Alamat {
  int? id;
  String? judul;
  String? lokasi;
  int? utama;

  Alamat({
    this.id,
    this.judul,
    this.lokasi,
    this.utama,
  });

  Alamat.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    judul = json['judul'];
    lokasi = json['lokasi'];
    utama = json['utama'] == true || json['utama'] == 1 ? 1 : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['judul'] = judul;
    data['lokasi'] = lokasi;
    data['utama'] = utama;
    return data;
  }
}
