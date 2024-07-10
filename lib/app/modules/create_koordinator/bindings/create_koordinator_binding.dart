import 'package:get/get.dart';
import 'package:kepulangan/app/modules/create_koordinator/controllers/create_koordinator_controller.dart';

class CreateKoordinatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateKoordinatorController>(
      () => CreateKoordinatorController(),
    );
  }
}
