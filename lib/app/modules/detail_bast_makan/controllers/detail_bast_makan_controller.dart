import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/bast_makan.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/base_client.dart';

class DetailBastMakanController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static DetailBastMakanController get to => Get.find();

  late TabController tabController;
  final bastMakan = BastMakan().obs;

  @override
  void onInit() {
    bastMakan.value = Get.arguments;
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
          .post("/api/bast-makan/terlaksana/${bastMakan.value.id}", {
        'terlaksana': 1,
      });
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        bastMakan.value = BastMakan.fromJson(r['data']);
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            "${bastMakan.value.purchaseOrder ?? "Fasilitas Makan"} berhasil terlaksana");
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
          .delete("/api/bast-makan/destroy/${bastMakan.value.id}");
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            "${bastMakan.value.purchaseOrder ?? "Fasilitas Makan"} berhasil dihapus");
        Get.back();
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  bool isCompleteBastMakan() {
    return bastMakan.value.fotoPenyediaJasa != null &&
            bastMakan.value.fotoSerahTerima != null &&
            bastMakan.value.fotoInvoice != null
        ? true
        : false;
  }

  bool isCompleteMakan() {
    return bastMakan.value.makan!.isNotEmpty ? true : false;
  }

  bool isShowTerlaksana() {
    return isCompleteBastMakan() == true &&
            isCompleteMakan() == true &&
            bastMakan.value.terlaksana == 0
        ? true
        : false;
  }

  bool isShowExport() {
    return isCompleteBastMakan() == true && isCompleteMakan() == true
        ? true
        : false;
  }

  bool isShowEdit() {
    return bastMakan.value.terlaksana == 0 || AuthService.to.isAdmin.isTrue
        ? true
        : false;
  }

  bool isShowDelete() {
    return bastMakan.value.terlaksana == 0 || AuthService.to.isAdmin.isTrue
        ? true
        : false;
  }
}
