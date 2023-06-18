class PihakKedua {
  int? id;
  String? nama;
  String? noIdentitas;
  String? jabatan;
  String? instansi;
  String? alamat;
  String? noTelp;

  PihakKedua({
    this.id,
    this.nama,
    this.noIdentitas,
    this.jabatan,
    this.instansi,
    this.alamat,
    this.noTelp,
  });

  PihakKedua.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    nama = json['nama'];
    noIdentitas = json['no_identitas'];
    jabatan = json['jabatan'];
    instansi = json['instansi'];
    alamat = json['alamat'];
    noTelp = json['no_telp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    data['no_identitas'] = noIdentitas;
    data['jabatan'] = jabatan;
    data['instansi'] = instansi;
    data['alamat'] = alamat;
    data['no_telp'] = noTelp;
    return data;
  }
}
