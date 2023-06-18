import 'package:get/get.dart';

import '../controllers/keamanan_controller.dart';

class KeamananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KeamananController>(
      () => KeamananController(),
    );
  }
}
