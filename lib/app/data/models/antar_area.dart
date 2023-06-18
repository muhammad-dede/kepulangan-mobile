import 'package:kepulangan/app/data/models/area.dart';

class AntarArea {
  Area? fromArea;
  Area? toArea;

  AntarArea({
    this.fromArea,
    this.toArea,
  });

  AntarArea.fromJson(Map<String, dynamic> json) {
    fromArea =
        json['from_area'] != null ? Area.fromJson(json['from_area']) : null;
    toArea = json['to_area'] != null ? Area.fromJson(json['to_area']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fromArea != null) {
      data['from_area'] = fromArea!.toJson();
    }
    if (toArea != null) {
      data['to_area'] = toArea!.toJson();
    }
    return data;
  }
}
