import 'package:get/get.dart';

import '../controllers/create_bast_darat_controller.dart';

class CreateBastDaratBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateBastDaratController>(
      () => CreateBastDaratController(),
    );
  }
}
