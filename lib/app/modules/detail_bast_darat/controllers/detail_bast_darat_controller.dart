import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/bast_darat.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/base_client.dart';

class DetailBastDaratController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static DetailBastDaratController get to => Get.find();

  late TabController tabController;
  final bastDarat = BastDarat().obs;

  @override
  void onInit() {
    bastDarat.value = Get.arguments;
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  bool isAnyEmpty() {
    return bastDarat.value.fotoPenyediaJasa == null ||
            bastDarat.value.fotoSerahTerima == null ||
            bastDarat.value.darat!.isEmpty ||
            bastDarat.value.darat!
                .where((element) => element.fotoBast == null)
                .isNotEmpty
        ? true
        : false;
  }

  bool isCanTerlaksana() {
    return isAnyEmpty() == false && bastDarat.value.terlaksana == 0
        ? true
        : false;
  }

  bool isCanExport() {
    return bastDarat.value.terlaksana == 1 ? true : false;
  }

  bool isCanEdit() {
    return bastDarat.value.terlaksana == 0 || AuthService.to.isAdmin.isTrue
        ? true
        : false;
  }

  bool isCanDelete() {
    return bastDarat.value.terlaksana == 0 || AuthService.to.isAdmin.isTrue
        ? true
        : false;
  }

  Future<void> terlaksana() async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response = await BaseClient()
          .post("/api/bast-darat/terlaksana/${bastDarat.value.id}", {
        'terlaksana': 1,
      });
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        bastDarat.value = BastDarat.fromJson(r['data']);
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            "${bastDarat.value.purchaseOrder ?? "Fasilitas Darat"} berhasil terlaksana");
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
          .delete("/api/bast-darat/destroy/${bastDarat.value.id}");
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            "${bastDarat.value.purchaseOrder ?? "Fasilitas Darat"} berhasil dihapus");
        Get.back();
      });
    } finally {
      EasyLoading.dismiss();
    }
  }
}
