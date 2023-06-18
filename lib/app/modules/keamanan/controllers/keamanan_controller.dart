import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/base_client.dart';

class KeamananController extends GetxController {
  final formState = GlobalKey<FormState>();
  final passwordCurrentController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  bool isHidePasswordCurrent = true;
  bool isHidePassword = true;
  bool isHidePasswordConfirmation = true;

  @override
  void onClose() {
    passwordCurrentController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.onClose();
  }

  String? validator(String value) {
    if (value.isEmpty) {
      return "Bidang ini wajib diisi";
    }
    return null;
  }

  Future<void> save() async {
    if (formState.currentState!.validate()) {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      try {
        final response = await BaseClient().post("/api/auth/update/password", {
          'password_current': passwordCurrentController.text.toString(),
          'password': passwordController.text.toString(),
          'password_confirmation':
              passwordConfirmationController.text.toString(),
        });
        response.fold((l) {
          EasyLoading.showError(l.toString());
        }, (r) async {
          await AuthService.to.me();
          Get.back();
          EasyLoading.showSuccess('Berhasil disimpan');
        });
      } finally {
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.showError('Gagal.\nPeriksa kembali inputan Anda');
    }
  }
}
