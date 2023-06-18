import 'package:get/get.dart';

import '../controllers/create_pengguna_controller.dart';

class CreatePenggunaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatePenggunaController>(
      () => CreatePenggunaController(),
    );
  }
}
