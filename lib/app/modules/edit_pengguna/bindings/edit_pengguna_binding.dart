import 'package:get/get.dart';

import '../controllers/edit_pengguna_controller.dart';

class EditPenggunaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditPenggunaController>(
      () => EditPenggunaController(),
    );
  }
}
