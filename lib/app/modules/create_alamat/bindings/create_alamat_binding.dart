import 'package:get/get.dart';

import '../controllers/create_alamat_controller.dart';

class CreateAlamatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateAlamatController>(
      () => CreateAlamatController(),
    );
  }
}
