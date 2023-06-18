import 'package:get/get.dart';

import '../controllers/edit_pihak_kedua_controller.dart';

class EditPihakKeduaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditPihakKeduaController>(
      () => EditPihakKeduaController(),
    );
  }
}
