import 'package:get/get.dart';

import '../controllers/edit_bast_darat_controller.dart';

class EditBastDaratBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditBastDaratController>(
      () => EditBastDaratController(),
    );
  }
}
