import 'package:get/get.dart';

import '../controllers/detail_bast_darat_controller.dart';

class DetailBastDaratBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailBastDaratController>(
      () => DetailBastDaratController(),
    );
  }
}
