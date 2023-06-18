import 'package:get/get.dart';

import '../controllers/edit_penyedia_jasa_controller.dart';

class EditPenyediaJasaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditPenyediaJasaController>(
      () => EditPenyediaJasaController(),
    );
  }
}
