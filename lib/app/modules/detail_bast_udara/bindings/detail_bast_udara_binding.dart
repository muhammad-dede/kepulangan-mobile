import 'package:get/get.dart';

import '../controllers/detail_bast_udara_controller.dart';

class DetailBastUdaraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailBastUdaraController>(
      () => DetailBastUdaraController(),
    );
  }
}
