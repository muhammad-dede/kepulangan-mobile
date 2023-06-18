import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/services/storage_service.dart';

class ThemeService extends GetxService {
  static ThemeService get to => Get.find();

  RxBool isDarkMode = false.obs;

  // Initial
  Future<ThemeService> init() async {
    await getThemeMode();
    return this;
  }

  Future<void> getThemeMode() async {
    await StorageService.to.read('isDarkMode') != null
        ? isDarkMode.value = true
        : isDarkMode.value = false;
  }

  Future<void> changeThemeMode() async {
    if (StorageService.to.read('isDarkMode') != null) {
      await StorageService.to.remove('isDarkMode');
      Get.changeThemeMode(ThemeMode.light);
      isDarkMode.value = false;
    } else {
      await StorageService.to.write('isDarkMode', true);
      Get.changeThemeMode(ThemeMode.dark);
      isDarkMode.value = true;
    }
  }
}
