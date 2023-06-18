class Total {
  int? totalPmi;
  int? totalCpmi;
  int? totalAbk;
  int? totalJenazah;

  Total({
    this.totalPmi,
    this.totalCpmi,
    this.totalAbk,
    this.totalJenazah,
  });

  Total.fromJson(Map<String, dynamic> json) {
    totalPmi =
        json['total_pmi'] != null ? int.parse(json['total_pmi'].toString()) : 0;
    totalCpmi = json['total_cpmi'] != null
        ? int.parse(json['total_cpmi'].toString())
        : 0;
    totalAbk =
        json['total_abk'] != null ? int.parse(json['total_abk'].toString()) : 0;
    totalJenazah = json['total_jenazah'] != null
        ? int.parse(json['total_jenazah'].toString())
        : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_pmi'] = totalPmi;
    data['total_cpmi'] = totalCpmi;
    data['total_abk'] = totalAbk;
    data['total_jenazah'] = totalJenazah;
    return data;
  }
}
