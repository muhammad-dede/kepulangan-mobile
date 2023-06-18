import 'package:get/get.dart';

import '../controllers/edit_imigran_controller.dart';

class EditImigranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditImigranController>(
      () => EditImigranController(),
    );
  }
}
