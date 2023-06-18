import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/bast_udara.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/base_client.dart';

class DetailBastUdaraController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static DetailBastUdaraController get to => Get.find();

  late TabController tabController;
  final bastUdara = BastUdara().obs;

  @override
  void onInit() {
    bastUdara.value = Get.arguments;
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  bool isAnyEmpty() {
    return bastUdara.value.fotoPenyediaJasa == null ||
            bastUdara.value.fotoSerahTerima == null ||
            bastUdara.value.udara!.isEmpty ||
            bastUdara.value.udara!
                .where((element) => element.fotoBoardingPass == null)
                .isNotEmpty ||
            bastUdara.value.spu == null ||
            bastUdara.value.spu!.spuTiket!.isEmpty
        ? true
        : false;
  }

  bool isCanTerlaksana() {
    return isAnyEmpty() == false && bastUdara.value.terlaksana == 0
        ? true
        : false;
  }

  bool isCanSpu() {
    return bastUdara.value.fotoPenyediaJasa != null &&
            bastUdara.value.fotoSerahTerima != null &&
            bastUdara.value.udara!.isNotEmpty &&
            bastUdara.value.udara!
                .where((element) => element.fotoBoardingPass == null)
                .isEmpty &&
            bastUdara.value.spu == null &&
            bastUdara.value.terlaksana == 0
        ? true
        : false;
  }

  bool isCanEditSpu() {
    return bastUdara.value.fotoPenyediaJasa != null &&
            bastUdara.value.fotoSerahTerima != null &&
            bastUdara.value.udara!.isNotEmpty &&
            bastUdara.value.udara!
                .where((element) => element.fotoBoardingPass == null)
                .isEmpty &&
            bastUdara.value.spu != null &&
            bastUdara.value.terlaksana == 0
        ? true
        : false;
  }

  bool isCanExport() {
    return bastUdara.value.terlaksana == 1 ? true : false;
  }

  bool isCanEdit() {
    return bastUdara.value.terlaksana == 0 || AuthService.to.isAdmin.isTrue
        ? true
        : false;
  }

  bool isCanDelete() {
    return bastUdara.value.terlaksana == 0 || AuthService.to.isAdmin.isTrue
        ? true
        : false;
  }

  Future<void> terlaksana() async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response = await BaseClient()
          .post("/api/bast-udara/terlaksana/${bastUdara.value.id}", {
        'terlaksana': 1,
      });
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        bastUdara.value = BastUdara.fromJson(r['data']);
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            "${bastUdara.value.purchaseOrder ?? "Fasilitas Udara"} berhasil terlaksana");
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
          .delete("/api/bast-udara/destroy/${bastUdara.value.id}");
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            "${bastUdara.value.purchaseOrder ?? "Fasilitas Udara"} berhasil dihapus");
        Get.back();
      });
    } finally {
      EasyLoading.dismiss();
    }
  }
}
