import 'package:get/get.dart';

import '../controllers/edit_bast_udara_controller.dart';

class EditBastUdaraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditBastUdaraController>(
      () => EditBastUdaraController(),
    );
  }
}
