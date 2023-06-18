import 'package:get/get.dart';

import '../controllers/penyedia_jasa_controller.dart';

class PenyediaJasaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PenyediaJasaController>(
      () => PenyediaJasaController(),
    );
  }
}
