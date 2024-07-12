class PenyediaJasa {
  int? id;
  String? namaPerusahaan;
  String? alamat;
  String? email;
  String? noTelp;
  String? up;
  String? noPks;
  DateTime? tanggalPks;
  String? noDipa;
  DateTime? tanggalDipa;

  PenyediaJasa({
    this.id,
    this.namaPerusahaan,
    this.alamat,
    this.email,
    this.noTelp,
    this.up,
    this.noPks,
    this.tanggalPks,
    this.noDipa,
    this.tanggalDipa,
  });

  PenyediaJasa.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    namaPerusahaan = json['nama_perusahaan'];
    alamat = json['alamat'];
    email = json['email'];
    noTelp = json['no_telp'];
    up = json['up'];
    noPks = json['no_pks'];
    tanggalPks = json["tanggal_pks"] != null
        ? DateTime.parse(json["tanggal_pks"])
        : null;
    noDipa = json['no_dipa'];
    tanggalDipa = tanggalPks = json["tanggal_dipa"] != null
        ? DateTime.parse(json["tanggal_dipa"])
        : null;
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
    data['tanggal_pks'] = tanggalPks?.toIso8601String();
    data['no_dipa'] = noDipa;
    data['tanggal_dipa'] = tanggalDipa?.toIso8601String();
    return data;
  }
}
