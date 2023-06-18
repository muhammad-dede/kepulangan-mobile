import 'package:get/get.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/storage_service.dart';

class IntroductionController extends GetxController {
  Future<void> doneIntoduction() async {
    if (StorageService.to.read("introduction") == null ||
        StorageService.to.read("introduction") == false) {
      await StorageService.to.write("introduction", true);
      Get.offAllNamed(Routes.login);
    }
  }
}
