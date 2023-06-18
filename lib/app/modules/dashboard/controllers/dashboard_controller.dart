import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/area.dart';
import 'package:kepulangan/app/data/models/chart.dart';
import 'package:kepulangan/app/data/models/total.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/base_client.dart';

class DashboardController extends GetxController {
  static DashboardController get to => Get.find();

  RxList<Area> listArea = <Area>[].obs;
  RxList<Chart> listChart = <Chart>[].obs;
  Rx<Total> total = Total().obs;

  @override
  void onInit() async {
    await getArea();
    await getTotal();
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
    await getArea();
    await AuthService.to.me();
    await getTotal();
  }

  Future<void> getArea() async {
    final response = await BaseClient().get("/api/referensi/area");
    response.fold((l) {
      listArea.value = [];
    }, (r) {
      List data = r['data'];
      listArea.value = data.map((e) => Area.fromJson(e)).toList();
    });
  }

  Future<void> getTotal() async {
    final response = await BaseClient().get("/api/dashboard/total");
    response.fold((l) {
      total.value = Total();
    }, (r) {
      total.value = Total.fromJson(r['data']);
    });
  }

  Future<List<Chart>> getChartJenisKelamin(int? idLayanan) async {
    try {
      final response = await BaseClient()
          .get("/api/dashboard/chart-jenis-kelamin/${idLayanan ?? ""}");
      response.fold((l) {
        throw (l.toString());
      }, (r) {
        List data = r['data'];
        listChart.value = data.map((e) => Chart.fromJson(e)).toList();
      });
      return listChart;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Chart>> getChartMasalah(int? idLayanan) async {
    try {
      final response = await BaseClient()
          .get("/api/dashboard/chart-masalah/${idLayanan ?? ""}");
      response.fold((l) {
        throw (l.toString());
      }, (r) {
        List data = r['data'];
        listChart.value = data.map((e) => Chart.fromJson(e)).toList();
      });
      return listChart;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Chart>> getChartNegara(int? idLayanan) async {
    try {
      final response = await BaseClient()
          .get("/api/dashboard/chart-negara/${idLayanan ?? ""}");
      response.fold((l) {
        throw (l.toString());
      }, (r) {
        List data = r['data'];
        listChart.value = data.map((e) => Chart.fromJson(e)).toList();
      });
      return listChart;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Chart>> getChartProvinsi(int? idLayanan) async {
    try {
      final response = await BaseClient()
          .get("/api/dashboard/chart-provinsi/${idLayanan ?? ""}");
      response.fold((l) {
        throw (l.toString());
      }, (r) {
        List data = r['data'];
        listChart.value = data.map((e) => Chart.fromJson(e)).toList();
      });
      return listChart;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Chart>> getChartKabKota(int? idLayanan) async {
    try {
      final response = await BaseClient()
          .get("/api/dashboard/chart-kab-kota/${idLayanan ?? ""}");
      response.fold((l) {
        throw (l.toString());
      }, (r) {
        List data = r['data'];
        listChart.value = data.map((e) => Chart.fromJson(e)).toList();
      });
      return listChart;
    } catch (e) {
      rethrow;
    }
  }
}
