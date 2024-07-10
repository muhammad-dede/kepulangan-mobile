class PenyediaJasa {
  int? id;
  String? namaPerusahaan;
  String? alamat;
  String? email;
  String? noTelp;
  String? up;
  String? noPks;
  String? tahunPks;
  String? noDiva;
  String? tahunDiva;

  PenyediaJasa({
    this.id,
    this.namaPerusahaan,
    this.alamat,
    this.email,
    this.noTelp,
    this.up,
    this.noPks,
    this.tahunPks,
    this.noDiva,
    this.tahunDiva,
  });

  PenyediaJasa.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    namaPerusahaan = json['nama_perusahaan'];
    alamat = json['alamat'];
    email = json['email'];
    noTelp = json['no_telp'];
    up = json['up'];
    noPks = json['no_pks'];
    tahunPks = json['tahun_pks'];
    noDiva = json['no_diva'];
    tahunDiva = json['tahun_diva'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama_perusahaan'] = namaPerusahaan;
    data['alamat'] = alamat;
    data['email'] = email;
    data['no_telp'] = noTelp;
    data['up'] = up;
    data['no_pks'] = noPks;
    data['tahun_pks'] = tahunPks;
    data['no_diva'] = noDiva;
    data['tahun_diva'] = tahunDiva;
    return data;
  }
}
