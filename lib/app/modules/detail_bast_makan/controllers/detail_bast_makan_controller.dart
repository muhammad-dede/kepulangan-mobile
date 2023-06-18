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

  bool isAnyEmpty() {
    return bastMakan.value.fotoPenyediaJasa == null ||
            bastMakan.value.fotoSerahTerima == null ||
            bastMakan.value.fotoInvoice == null ||
            bastMakan.value.makan!.isEmpty
        ? true
        : false;
  }

  bool isCanTerlaksana() {
    return isAnyEmpty() == false && bastMakan.value.terlaksana == 0
        ? true
        : false;
  }

  bool isCanExport() {
    return bastMakan.value.terlaksana == 1 ? true : false;
  }

  bool isCanEdit() {
    return bastMakan.value.terlaksana == 0 || AuthService.to.isAdmin.isTrue
        ? true
        : false;
  }

  bool isCanDelete() {
    return bastMakan.value.terlaksana == 0 || AuthService.to.isAdmin.isTrue
        ? true
        : false;
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
}
