class Chart {
  String? label;
  int? value;

  Chart({
    this.label,
    this.value,
  });

  Chart.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'] != null ? int.parse(json['value'].toString()) : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}
