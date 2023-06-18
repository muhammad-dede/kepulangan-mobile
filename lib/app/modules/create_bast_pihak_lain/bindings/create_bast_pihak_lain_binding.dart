import 'package:get/get.dart';

import '../controllers/create_bast_pihak_lain_controller.dart';

class CreateBastPihakLainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateBastPihakLainController>(
      () => CreateBastPihakLainController(),
    );
  }
}
