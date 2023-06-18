import 'package:get/get.dart';

import '../controllers/create_penyedia_jasa_controller.dart';

class CreatePenyediaJasaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatePenyediaJasaController>(
      () => CreatePenyediaJasaController(),
    );
  }
}
