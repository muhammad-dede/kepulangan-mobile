import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/bast_pihak_lain.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/base_client.dart';

class DetailBastPihakLainController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static DetailBastPihakLainController get to => Get.find();

  late TabController tabController;
  final bastPihakLain = BastPihakLain().obs;

  @override
  void onInit() {
    bastPihakLain.value = Get.arguments;
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> terlaksana() async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response = await BaseClient()
          .post("/api/bast-pihak-lain/terlaksana/${bastPihakLain.value.id}", {
        'terlaksana': 1,
      });
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        bastPihakLain.value = BastPihakLain.fromJson(r['data']);
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            "${bastPihakLain.value.pihakKedua?.nama ?? "Pihak Lain"} berhasil terlaksana");
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> destroy() async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response = await BaseClient()
          .delete("/api/bast-pihak-lain/destroy/${bastPihakLain.value.id}");
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            "${bastPihakLain.value.pihakKedua?.nama ?? "Pihak Lain"} berhasil dihapus");
        Get.back();
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  bool isCompleteBastPihakLain() {
    return bastPihakLain.value.fotoPihakKedua != null &&
            bastPihakLain.value.fotoSerahTerima != null
        ? true
        : false;
  }

  bool isCompleteJemputPihakLain() {
    return bastPihakLain.value.jemputPihakLain!.isNotEmpty ? true : false;
  }

  bool isShowTerlaksana() {
    return isCompleteBastPihakLain() == true &&
            isCompleteJemputPihakLain() == true &&
            bastPihakLain.value.terlaksana == 0
        ? true
        : false;
  }

  bool isShowExport() {
    return isCompleteBastPihakLain() == true &&
            isCompleteJemputPihakLain() == true
        ? true
        : false;
  }

  bool isShowEdit() {
    return bastPihakLain.value.terlaksana == 0 || AuthService.to.isAdmin.isTrue
        ? true
        : false;
  }

  bool isShowDelete() {
    return bastPihakLain.value.terlaksana == 0 || AuthService.to.isAdmin.isTrue
        ? true
        : false;
  }
}
