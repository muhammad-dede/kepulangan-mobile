import 'package:get/get.dart';

import '../controllers/create_imigran_controller.dart';

class CreateImigranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateImigranController>(
      () => CreateImigranController(),
    );
  }
}
