import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/area.dart';
import 'package:kepulangan/app/data/models/chart.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/base_client.dart';

class DashboardController extends GetxController {
  static DashboardController get to => Get.find();

  RxList<Area> listArea = <Area>[
    Area(id: 1, nama: "Helpdesk"),
    Area(id: 2, nama: "Lounge"),
    Area(id: 3, nama: "Shelter"),
    Area(id: 4, nama: "Cargo"),
  ].obs;

  RxList<Map<dynamic, dynamic>> listTotalLayanan = <Map<dynamic, dynamic>>[
    {"id": 1, "nama": "PMI", "total": 0},
    {"id": 2, "nama": "ABK", "total": 0},
    {"id": 3, "nama": "Sakit", "total": 0},
    {"id": 4, "nama": "Anak", "total": 0},
    {"id": 5, "nama": "CPMI", "total": 0},
    {"id": 6, "nama": "Jenazah", "total": 0},
  ].obs;

  RxInt grandTotal = 0.obs;

  @override
  void onInit() {
    getArea();
    getTotalLayanan();
    super.onInit();
  }

  @override
  void onReady() {
    ever(MainController.to.refreshKey, (_) {
      refreshData();
    });
    super.onReady();
  }

  Future<void> refreshData() async {
    await AuthService.to.me();
    await getArea();
    await getTotalLayanan();
  }

  Future<void> getArea() async {
    final response = await BaseClient().get("/api/referensi/area");
    response.fold((l) {
      listArea.value = listArea;
    }, (r) {
      List data = r['data'];
      listArea.value = data.map((e) => Area.fromJson(e)).toList();
    });
  }

  Future<void> getTotalLayanan() async {
    final response = await BaseClient().get("/api/dashboard/total/layanan");
    response.fold((l) {
      listTotalLayanan.value = listTotalLayanan;
    }, (r) {
      List data = r['data'];
      for (var i = 0; i < listTotalLayanan.length; i++) {
        listTotalLayanan[i] = data.firstWhere((item) =>
            item['id'].toString() == listTotalLayanan[i]['id'].toString());
      }
      grandTotal.value = listTotalLayanan.fold<int>(
          0, (sum, item) => sum + int.parse(item['total']));
    });
  }

  Future<List<Chart>> getTotalJenisKelamin(int? idLayanan) async {
    try {
      List<Chart> listTotal = [];
      final response = await BaseClient()
          .get("/api/dashboard/total/jenis-kelamin/${idLayanan ?? ""}");
      response.fold((l) {
        throw (l.toString());
      }, (r) {
        List data = r['data'];
        listTotal = data.map((e) => Chart.fromJson(e)).toList();
      });
      return listTotal;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Chart>> getTotalMasalah(int? idLayanan) async {
    try {
      List<Chart> listTotal = [];
      final response = await BaseClient()
          .get("/api/dashboard/total/masalah/${idLayanan ?? ""}");
      response.fold((l) {
        throw (l.toString());
      }, (r) {
        List data = r['data'];
        listTotal = data.map((e) => Chart.fromJson(e)).toList();
      });
      return listTotal;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Chart>> getTotalNegara(int? idLayanan) async {
    try {
      List<Chart> listTotal = [];
      final response = await BaseClient()
          .get("/api/dashboard/total/negara/${idLayanan ?? ""}");
      response.fold((l) {
        throw (l.toString());
      }, (r) {
        List data = r['data'];
        listTotal = data.map((e) => Chart.fromJson(e)).toList();
      });
      return listTotal;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Chart>> getTotalProvinsi(int? idLayanan) async {
    try {
      List<Chart> listTotal = [];
      final response = await BaseClient()
          .get("/api/dashboard/total/provinsi/${idLayanan ?? ""}");
      response.fold((l) {
        throw (l.toString());
      }, (r) {
        List data = r['data'];
        listTotal = data.map((e) => Chart.fromJson(e)).toList();
      });
      return listTotal;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Chart>> getTotalKabKota(int? idLayanan) async {
    try {
      List<Chart> listTotal = [];
      final response = await BaseClient()
          .get("/api/dashboard/total/kab-kota/${idLayanan ?? ""}");
      response.fold((l) {
        throw (l.toString());
      }, (r) {
        List data = r['data'];
        listTotal = data.map((e) => Chart.fromJson(e)).toList();
      });
      return listTotal;
    } catch (e) {
      rethrow;
    }
  }
}
