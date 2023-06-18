import 'package:get/get.dart';

import '../controllers/spu_controller.dart';

class SpuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpuController>(
      () => SpuController(),
    );
  }
}
