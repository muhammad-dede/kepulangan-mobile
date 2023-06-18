import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/base_client.dart';
import 'package:kepulangan/app/services/storage_service.dart';

class PengaturanController extends GetxController {
  Future<void> logout() async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    try {
      final response = await BaseClient().delete('/api/auth/logout');
      response.fold((l) async {
        EasyLoading.showError(l.toString());
      }, (r) async {
        await StorageService.to.remove('token');
        Get.offAllNamed(Routes.login);
      });
    } finally {
      EasyLoading.dismiss();
    }
  }
}
