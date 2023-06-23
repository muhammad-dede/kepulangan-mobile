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

  bool isCompleteBastUdara() {
    return bastUdara.value.fotoPenyediaJasa != null &&
            bastUdara.value.fotoSerahTerima != null
        ? true
        : false;
  }

  bool isCompleteUdara() {
    return bastUdara.value.udara!.isNotEmpty &&
            bastUdara.value.udara!
                .where((element) => element.fotoBoardingPass == null)
                .isEmpty
        ? true
        : false;
  }

  bool isCompleteSpu() {
    return bastUdara.value.spu != null ? true : false;
  }

  bool isCompleteSpuTiket() {
    return bastUdara.value.spu!.spuTiket!.isNotEmpty &&
            bastUdara.value.spu!.spuTiket!
                .where((element) => element.fotoTiket == null)
                .isEmpty
        ? true
        : false;
  }

  bool isShowTerlaksana() {
    return isCompleteBastUdara() == true &&
            isCompleteUdara() == true &&
            isCompleteSpu() == true &&
            isCompleteSpuTiket() == true &&
            bastUdara.value.terlaksana == 0
        ? true
        : false;
  }

  bool isShowSpu() {
    return isCompleteBastUdara() == true &&
            isCompleteUdara() == true &&
            (bastUdara.value.terlaksana == 0 || AuthService.to.isAdmin.isTrue)
        ? true
        : false;
  }

  bool isShowExportBastUdara() {
    return isCompleteBastUdara() == true && isCompleteUdara() == true
        ? true
        : false;
  }

  bool isShowExportSpu() {
    return isCompleteSpu() == true && isCompleteSpuTiket() == true
        ? true
        : false;
  }

  bool isShowEdit() {
    return bastUdara.value.terlaksana == 0 || AuthService.to.isAdmin.isTrue
        ? true
        : false;
  }

  bool isShowDelete() {
    return bastUdara.value.terlaksana == 0 || AuthService.to.isAdmin.isTrue
        ? true
        : false;
  }
}
