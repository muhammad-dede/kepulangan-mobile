import 'package:get/get.dart';

import '../controllers/detail_bast_pihak_lain_controller.dart';

class DetailBastPihakLainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailBastPihakLainController>(
      () => DetailBastPihakLainController(),
    );
  }
}
