import 'package:get/get.dart';

import '../controllers/create_pihak_kedua_controller.dart';

class CreatePihakKeduaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatePihakKeduaController>(
      () => CreatePihakKeduaController(),
    );
  }
}
