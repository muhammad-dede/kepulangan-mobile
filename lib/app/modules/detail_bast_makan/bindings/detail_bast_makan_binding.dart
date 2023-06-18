import 'package:get/get.dart';

import '../controllers/detail_bast_makan_controller.dart';

class DetailBastMakanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailBastMakanController>(
      () => DetailBastMakanController(),
    );
  }
}
