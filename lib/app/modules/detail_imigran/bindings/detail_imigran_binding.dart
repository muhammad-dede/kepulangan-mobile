import 'package:get/get.dart';

import '../controllers/detail_imigran_controller.dart';

class DetailImigranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailImigranController>(
      () => DetailImigranController(),
    );
  }
}
