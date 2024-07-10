import 'package:get/get.dart';
import 'package:kepulangan/app/modules/edit_koordinator/controllers/edit_koordinator_controller.dart';

class EditKoordinatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditKoordinatorController>(
      () => EditKoordinatorController(),
    );
  }
}
