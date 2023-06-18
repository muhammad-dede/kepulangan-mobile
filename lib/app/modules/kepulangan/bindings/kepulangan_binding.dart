import 'package:get/get.dart';

import '../controllers/kepulangan_controller.dart';

class KepulanganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KepulanganController>(
      () => KepulanganController(),
    );
  }
}
