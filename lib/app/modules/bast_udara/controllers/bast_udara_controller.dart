import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kepulangan/app/data/models/bast_udara.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/base_client.dart';

class BastUdaraController extends GetxController {
  static BastUdaraController get to => Get.find();

  final PagingController<int, BastUdara> pagingController =
      PagingController(firstPageKey: 1);

  static const int perPage = 10;

  RxList<BastUdara> listSearch = <BastUdara>[].obs;

  @override
  void onInit() {
    pagingController.addPageRequestListener((pageKey) => getData(pageKey));
    super.onInit();
  }

  @override
  void onReady() {
    ever(MainController.to.refreshKey, (_) {
      refreshData();
    });
    super.onReady();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  Future<void> refreshData() async {
    Future.sync(
      () => pagingController.refresh(),
    );
  }

  Future<void> getData(int pageKey) async {
    try {
      final response = await BaseClient()
          .get("/api/bast-udara?page=$pageKey&per_page=$perPage");
      response.fold((l) {
        throw (l.toString());
      }, (r) async {
        List data = r['data'];
        final isLastPage = data.length < perPage;
        if (isLastPage) {
          pagingController
              .appendLastPage(data.map((e) => BastUdara.fromJson(e)).toList());
        } else {
          pagingController.appendPage(
              data.map((e) => BastUdara.fromJson(e)).toList(), pageKey + 1);
        }
      });
    } catch (e) {
      pagingController.error = e;
    }
  }

  Future<List<BastUdara>> search(String? query) async {
    try {
      final response = await BaseClient().get("/api/bast-udara?search=$query");
      response.fold((l) {
        listSearch.value = [];
        throw (l.toString());
      }, (r) {
        List data = r['data'];
        listSearch.value = data.map((e) => BastUdara.fromJson(e)).toList();
      });
      return listSearch;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> terlaksana(BastUdara item) async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response =
          await BaseClient().post("/api/bast-udara/terlaksana/${item.id}", {
        'terlaksana': 1,
      });
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        await refreshData();
        EasyLoading.showSuccess(
            '${item.purchaseOrder ?? "Data"} berhasil disimpan');
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> destroy(BastUdara item) async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response =
          await BaseClient().delete("/api/bast-udara/destroy/${item.id}");
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        await refreshData();
        EasyLoading.showSuccess(
            '${item.purchaseOrder ?? "Data"} berhasil dihapus');
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  bool isCompleteBastUdara(BastUdara item) {
    return item.fotoPenyediaJasa != null && item.fotoSerahTerima != null
        ? true
        : false;
  }

  bool isCompleteUdara(BastUdara item) {
    return item.udara!.isNotEmpty &&
            item.udara!
                .where((element) => element.fotoBoardingPass == null)
                .isEmpty
        ? true
        : false;
  }

  bool isCompleteSpu(BastUdara item) {
    return item.spu != null ? true : false;
  }

  bool isCompleteSpuTiket(BastUdara item) {
    return item.spu!.spuTiket!.isNotEmpty &&
            item.spu!.spuTiket!
                .where((element) => element.fotoTiket == null)
                .isEmpty
        ? true
        : false;
  }

  bool isShowTerlaksana(BastUdara item) {
    return isCompleteBastUdara(item) == true &&
            isCompleteUdara(item) == true &&
            isCompleteSpu(item) == true &&
            isCompleteSpuTiket(item) == true &&
            item.terlaksana == 0
        ? true
        : false;
  }

  bool isShowSpu(BastUdara item) {
    return isCompleteBastUdara(item) == true &&
            isCompleteUdara(item) == true &&
            (item.terlaksana == 0 || AuthService.to.isAdmin.isTrue)
        ? true
        : false;
  }

  bool isShowExportBastUdara(BastUdara item) {
    return isCompleteBastUdara(item) == true && isCompleteUdara(item) == true
        ? true
        : false;
  }

  bool isShowExportSpu(BastUdara item) {
    return isCompleteSpu(item) == true && isCompleteSpuTiket(item) == true
        ? true
        : false;
  }

  bool isShowEdit(BastUdara item) {
    return item.terlaksana == 0 || AuthService.to.isAdmin.isTrue ? true : false;
  }

  bool isShowDelete(BastUdara item) {
    return item.terlaksana == 0 || AuthService.to.isAdmin.isTrue ? true : false;
  }
}
