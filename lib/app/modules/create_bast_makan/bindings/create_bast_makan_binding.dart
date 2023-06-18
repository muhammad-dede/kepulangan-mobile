import 'package:get/get.dart';

import '../controllers/create_bast_makan_controller.dart';

class CreateBastMakanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateBastMakanController>(
      () => CreateBastMakanController(),
    );
  }
}
