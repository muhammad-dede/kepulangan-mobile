import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/base_client.dart';
import 'package:kepulangan/app/services/storage_service.dart';

class LoginController extends GetxController {
  final formState = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isHidePassword = true;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  String? validator(String value) {
    if (value.isEmpty) {
      return "Bidang ini wajib diisi";
    }
    return null;
  }

  Future<void> login() async {
    if (formState.currentState!.validate()) {
      try {
        EasyLoading.show(
            status: 'loading...', maskType: EasyLoadingMaskType.black);
        final response = await BaseClient().post("/api/auth/login", {
          'email': emailController.text,
          'password': passwordController.text,
        });
        response.fold((l) {
          EasyLoading.showError(l.toString());
        }, (r) async {
          await StorageService.to.write('token', r['token']);
          await AuthService.to.me();
          Get.offAllNamed(AppPages.initial);
        });
      } finally {
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.showError('Gagal.\nPeriksa kembali inputan Anda');
    }
  }
}
