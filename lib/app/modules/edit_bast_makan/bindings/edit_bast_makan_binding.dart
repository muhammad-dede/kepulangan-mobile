import 'package:get/get.dart';

import '../controllers/edit_bast_makan_controller.dart';

class EditBastMakanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditBastMakanController>(
      () => EditBastMakanController(),
    );
  }
}
