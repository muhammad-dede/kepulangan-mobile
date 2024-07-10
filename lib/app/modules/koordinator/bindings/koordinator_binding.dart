import 'package:get/get.dart';
import 'package:kepulangan/app/modules/koordinator/controllers/koordinator_controller.dart';

class KoordinatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KoordinatorController>(
      () => KoordinatorController(),
    );
  }
}
