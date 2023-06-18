import 'package:get/get.dart';

import '../controllers/edit_alamat_controller.dart';

class EditAlamatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditAlamatController>(
      () => EditAlamatController(),
    );
  }
}
