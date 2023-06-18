import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/base_client.dart';

class DetailImigranController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static DetailImigranController get to => Get.find();

  late TabController tabController;

  final imigran = Imigran().obs;

  @override
  void onInit() {
    imigran.value = Get.arguments;
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  bool isDarat() {
    return imigran.value.darat != null && imigran.value.terlaksana == 1
        ? true
        : false;
  }

  bool isUdara() {
    return imigran.value.udara != null && imigran.value.terlaksana == 1
        ? true
        : false;
  }

  bool isSpu() {
    return imigran.value.udara?.bastUdara?.spu != null &&
            imigran.value.terlaksana == 1
        ? true
        : false;
  }

  bool isRujukRsPolri() {
    return imigran.value.rujukRsPolri != null && imigran.value.terlaksana == 1
        ? true
        : false;
  }

  bool isPulangMandiri() {
    return imigran.value.pulangMandiri != null && imigran.value.terlaksana == 1
        ? true
        : false;
  }

  bool isJemputKeluarga() {
    return imigran.value.jemputKeluarga != null && imigran.value.terlaksana == 1
        ? true
        : false;
  }

  bool isJemputPihakLain() {
    return imigran.value.jemputPihakLain != null &&
            imigran.value.terlaksana == 1
        ? true
        : false;
  }

  bool isCarAntarArea() {
    return imigran.value.area?.antarArea != null &&
            imigran.value.kepulangan == null
        ? true
        : false;
  }

  bool isCanKepulangan() {
    return imigran.value.kepulangan == null && imigran.value.terlaksana == 0
        ? true
        : false;
  }

  bool isCanEditKepulangan() {
    return (imigran.value.kepulangan != null &&
                imigran.value.terlaksana == 0 &&
                AuthService.to.isAdmin.isTrue) ||
            (imigran.value.kepulangan != null && imigran.value.terlaksana == 0)
        ? true
        : false;
  }

  bool isCanTerlaksana() {
    if (imigran.value.kepulangan != null && imigran.value.terlaksana == 0) {
      if (imigran.value.kepulangan?.id == 1) {
        return imigran.value.darat?.bastDarat?.terlaksana == 1 ? true : false;
      } else if (imigran.value.kepulangan?.id == 6) {
        return imigran.value.jemputPihakLain?.bastPihakLain?.terlaksana == 1
            ? true
            : false;
      } else {
        return true;
      }
    }
    return false;
  }

  bool isCanEdit() {
    return imigran.value.terlaksana == 0 || AuthService.to.isAdmin.isTrue
        ? true
        : false;
  }

  bool isCanDelete() {
    return imigran.value.terlaksana == 0 || AuthService.to.isAdmin.isTrue
        ? true
        : false;
  }

  Future<void> antarArea() async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response = await BaseClient()
          .post("/api/imigran/antar-area/${imigran.value.id}", {
        'id_area': imigran.value.area?.antarArea?.toArea?.id,
      });
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        imigran.value = Imigran.fromJson(r['data']);
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            "${imigran.value.nama ?? "Data"} berhasil diantar ke ${imigran.value.area?.nama ?? "-"}");
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> destroy() async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response =
          await BaseClient().delete("/api/imigran/destroy/${imigran.value.id}");
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            "${imigran.value.nama ?? "Data"} berhasil dihapus");
        Get.back();
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> terlaksana() async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response = await BaseClient()
          .post("/api/imigran/terlaksana/${imigran.value.id}", {
        'terlaksana': 1,
      });
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        imigran.value = Imigran.fromJson(r['data']);
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            "${imigran.value.nama ?? "Data"} berhasil terlaksana");
      });
    } finally {
      EasyLoading.dismiss();
    }
  }
}
