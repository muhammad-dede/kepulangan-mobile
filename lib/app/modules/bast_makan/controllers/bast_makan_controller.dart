import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kepulangan/app/data/models/bast_makan.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/base_client.dart';

class BastMakanController extends GetxController {
  static BastMakanController get to => Get.find();

  final PagingController<int, BastMakan> pagingController =
      PagingController(firstPageKey: 1);

  static const int perPage = 10;

  RxList<BastMakan> listSearch = <BastMakan>[].obs;

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

  bool isCanTerlaksana(BastMakan item) {
    return item.fotoPenyediaJasa != null &&
            item.fotoSerahTerima != null &&
            item.fotoInvoice != null &&
            item.makan!.isNotEmpty &&
            item.terlaksana == 0
        ? true
        : false;
  }

  bool isCanExport(BastMakan item) {
    return item.terlaksana == 1 ? true : false;
  }

  bool isCanEdit(BastMakan item) {
    return item.terlaksana == 0 || AuthService.to.isAdmin.isTrue ? true : false;
  }

  bool isCanDelete(BastMakan item) {
    return item.terlaksana == 0 || AuthService.to.isAdmin.isTrue ? true : false;
  }

  Future<void> refreshData() async {
    Future.sync(
      () => pagingController.refresh(),
    );
  }

  Future<void> getData(int pageKey) async {
    try {
      final response = await BaseClient()
          .get("/api/bast-makan?page=$pageKey&per_page=$perPage");
      response.fold((l) {
        throw (l.toString());
      }, (r) async {
        List data = r['data'];
        final isLastPage = data.length < perPage;
        if (isLastPage) {
          pagingController
              .appendLastPage(data.map((e) => BastMakan.fromJson(e)).toList());
        } else {
          pagingController.appendPage(
              data.map((e) => BastMakan.fromJson(e)).toList(), pageKey + 1);
        }
      });
    } catch (e) {
      pagingController.error = e;
    }
  }

  Future<List<BastMakan>> search(String? query) async {
    try {
      final response = await BaseClient().get("/api/bast-makan?search=$query");
      response.fold((l) {
        listSearch.value = [];
        throw (l.toString());
      }, (r) {
        List data = r['data'];
        listSearch.value = data.map((e) => BastMakan.fromJson(e)).toList();
      });
      return listSearch;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> terlaksana(BastMakan item) async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response =
          await BaseClient().post("/api/bast-makan/terlaksana/${item.id}", {
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

  Future<void> destroy(BastMakan item) async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response =
          await BaseClient().delete("/api/bast-makan/destroy/${item.id}");
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
}
