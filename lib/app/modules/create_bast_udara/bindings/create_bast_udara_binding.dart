import 'package:get/get.dart';

import '../controllers/create_bast_udara_controller.dart';

class CreateBastUdaraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateBastUdaraController>(
      () => CreateBastUdaraController(),
    );
  }
}
