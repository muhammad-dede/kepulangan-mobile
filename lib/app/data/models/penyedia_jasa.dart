class PenyediaJasa {
  int? id;
  String? namaPerusahaan;
  String? alamat;
  String? email;
  String? noTelp;
  String? up;

  PenyediaJasa({
    this.id,
    this.namaPerusahaan,
    this.alamat,
    this.email,
    this.noTelp,
    this.up,
  });

  PenyediaJasa.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    namaPerusahaan = json['nama_perusahaan'];
    alamat = json['alamat'];
    email = json['email'];
    noTelp = json['no_telp'];
    up = json['up'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama_perusahaan'] = namaPerusahaan;
    data['alamat'] = alamat;
    data['email'] = email;
    data['no_telp'] = noTelp;
    data['up'] = up;
    return data;
  }
}
