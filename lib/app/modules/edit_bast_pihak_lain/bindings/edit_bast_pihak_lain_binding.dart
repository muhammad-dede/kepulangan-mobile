import 'package:get/get.dart';

import '../controllers/edit_bast_pihak_lain_controller.dart';

class EditBastPihakLainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditBastPihakLainController>(
      () => EditBastPihakLainController(),
    );
  }
}
