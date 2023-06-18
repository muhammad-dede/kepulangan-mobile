import 'package:get/get.dart';

import '../controllers/pengguna_controller.dart';

class PenggunaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PenggunaController>(
      () => PenggunaController(),
    );
  }
}
