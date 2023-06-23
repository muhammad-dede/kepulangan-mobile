import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kepulangan/app/data/models/bast_darat.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/base_client.dart';

class BastDaratController extends GetxController {
  static BastDaratController get to => Get.find();

  final PagingController<int, BastDarat> pagingController =
      PagingController(firstPageKey: 1);

  static const int perPage = 10;

  RxList<BastDarat> listSearch = <BastDarat>[].obs;

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
          .get("/api/bast-darat?page=$pageKey&per_page=$perPage");
      response.fold((l) {
        throw (l.toString());
      }, (r) async {
        List data = r['data'];
        final isLastPage = data.length < perPage;
        if (isLastPage) {
          pagingController
              .appendLastPage(data.map((e) => BastDarat.fromJson(e)).toList());
        } else {
          pagingController.appendPage(
              data.map((e) => BastDarat.fromJson(e)).toList(), pageKey + 1);
        }
      });
    } catch (e) {
      pagingController.error = e;
    }
  }

  Future<List<BastDarat>> search(String? query) async {
    try {
      final response = await BaseClient().get("/api/bast-darat?search=$query");
      response.fold((l) {
        listSearch.value = [];
        throw (l.toString());
      }, (r) {
        List data = r['data'];
        listSearch.value = data.map((e) => BastDarat.fromJson(e)).toList();
      });
      return listSearch;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> terlaksana(BastDarat item) async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response =
          await BaseClient().post("/api/bast-darat/terlaksana/${item.id}", {
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

  Future<void> destroy(BastDarat item) async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response =
          await BaseClient().delete("/api/bast-darat/destroy/${item.id}");
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

  bool isCompleteBastDarat(BastDarat item) {
    return item.fotoPenyediaJasa != null && item.fotoSerahTerima != null
        ? true
        : false;
  }

  bool isCompleteDarat(BastDarat item) {
    return item.darat!.isNotEmpty &&
            item.darat!.where((element) => element.fotoBast == null).isEmpty
        ? true
        : false;
  }

  bool isShowTerlaksana(BastDarat item) {
    return isCompleteBastDarat(item) == true &&
            isCompleteDarat(item) == true &&
            item.terlaksana == 0
        ? true
        : false;
  }

  bool isShowExport(BastDarat item) {
    return isCompleteBastDarat(item) == true && isCompleteDarat(item) == true
        ? true
        : false;
  }

  bool isShowEdit(BastDarat item) {
    return item.terlaksana == 0 || AuthService.to.isAdmin.isTrue ? true : false;
  }

  bool isShowDelete(BastDarat item) {
    return item.terlaksana == 0 || AuthService.to.isAdmin.isTrue ? true : false;
  }
}
