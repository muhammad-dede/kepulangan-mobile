import 'package:get/get.dart';

import '../controllers/pihak_kedua_controller.dart';

class PihakKeduaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PihakKeduaController>(
      () => PihakKeduaController(),
    );
  }
}
