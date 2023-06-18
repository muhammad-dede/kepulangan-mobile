import 'package:get/get.dart';
import 'package:kepulangan/app/modules/bast_darat/controllers/bast_darat_controller.dart';
import 'package:kepulangan/app/modules/bast_makan/controllers/bast_makan_controller.dart';
import 'package:kepulangan/app/modules/bast_pihak_lain/controllers/bast_pihak_lain_controller.dart';
import 'package:kepulangan/app/modules/bast_udara/controllers/bast_udara_controller.dart';
import 'package:kepulangan/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:kepulangan/app/modules/fasilitas/controllers/fasilitas_controller.dart';
import 'package:kepulangan/app/modules/imigran/controllers/imigran_controller.dart';
import 'package:kepulangan/app/modules/pengaturan/controllers/pengaturan_controller.dart';

import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );
    Get.lazyPut<ImigranController>(
      () => ImigranController(),
    );
    Get.lazyPut<FasilitasController>(
      () => FasilitasController(),
    );
    Get.lazyPut<BastMakanController>(
      () => BastMakanController(),
    );
    Get.lazyPut<BastDaratController>(
      () => BastDaratController(),
    );
    Get.lazyPut<BastUdaraController>(
      () => BastUdaraController(),
    );
    Get.lazyPut<BastPihakLainController>(
      () => BastPihakLainController(),
    );
    Get.lazyPut<PengaturanController>(
      () => PengaturanController(),
    );
  }
}
