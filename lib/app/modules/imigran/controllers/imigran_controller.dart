import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kepulangan/app/data/models/area.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/base_client.dart';

class ImigranController extends GetxController {
  static ImigranController get to => Get.find();

  RxList<Imigran> listSearch = <Imigran>[].obs;

  List<Area> listArea = [
    Area(id: 0, nama: "Semua"),
    Area(id: 1, nama: "Helpdesk"),
    Area(id: 2, nama: "Lounge"),
    Area(id: 3, nama: "Shelter"),
    Area(id: 4, nama: "Cargo"),
  ];

  RxInt idArea = 0.obs;

  static const int perPage = 10;

  final PagingController<int, Imigran> pagingController =
      PagingController(firstPageKey: 1);

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

  bool isDarat(Imigran item) {
    return item.darat != null && item.terlaksana == 1 ? true : false;
  }

  bool isUdara(Imigran item) {
    return item.udara != null && item.terlaksana == 1 ? true : false;
  }

  bool isSpu(Imigran item) {
    return item.udara?.bastUdara?.spu != null && item.terlaksana == 1
        ? true
        : false;
  }

  bool isRujukRsPolri(Imigran item) {
    return item.rujukRsPolri != null && item.terlaksana == 1 ? true : false;
  }

  bool isPulangMandiri(Imigran item) {
    return item.pulangMandiri != null && item.terlaksana == 1 ? true : false;
  }

  bool isJemputKeluarga(Imigran item) {
    return item.jemputKeluarga != null && item.terlaksana == 1 ? true : false;
  }

  bool isJemputPihakLain(Imigran item) {
    return item.jemputPihakLain != null && item.terlaksana == 1 ? true : false;
  }

  bool isCanAntarArea(Imigran item) {
    return item.area?.antarArea != null && item.kepulangan == null
        ? true
        : false;
  }

  bool isCanKepulangan(Imigran item) {
    return item.kepulangan == null && item.terlaksana == 0 ? true : false;
  }

  bool isCanEditKepulangan(Imigran item) {
    return (item.kepulangan != null &&
                item.terlaksana == 0 &&
                AuthService.to.isAdmin.isTrue) ||
            (item.kepulangan != null && item.terlaksana == 0)
        ? true
        : false;
  }

  bool isCanTerlaksana(Imigran item) {
    if (item.kepulangan != null && item.terlaksana == 0) {
      if (item.kepulangan?.id == 1) {
        return item.darat?.bastDarat?.terlaksana == 1 ? true : false;
      } else if (item.kepulangan?.id == 2) {
        return item.udara?.bastUdara?.terlaksana == 1 ? true : false;
      } else if (item.kepulangan?.id == 6) {
        return item.jemputPihakLain?.bastPihakLain?.terlaksana == 1
            ? true
            : false;
      } else {
        return true;
      }
    }
    return false;
  }

  bool isCanEdit(Imigran item) {
    return item.terlaksana == 0 || AuthService.to.isAdmin.isTrue ? true : false;
  }

  bool isCanDelete(Imigran item) {
    return item.terlaksana == 0 || AuthService.to.isAdmin.isTrue ? true : false;
  }

  Future<void> refreshData() async {
    Future.sync(
      () => pagingController.refresh(),
    );
  }

  Future<void> getData(int pageKey) async {
    try {
      final response = await BaseClient().get(
          "/api/imigran?page=$pageKey&per_page=$perPage&id_area=${idArea.value}");
      response.fold((l) {
        throw (l.toString());
      }, (r) async {
        List data = r['data'];
        final isLastPage = data.length < perPage;
        if (isLastPage) {
          pagingController
              .appendLastPage(data.map((e) => Imigran.fromJson(e)).toList());
        } else {
          pagingController.appendPage(
              data.map((e) => Imigran.fromJson(e)).toList(), pageKey + 1);
        }
      });
    } catch (e) {
      pagingController.error = e;
    }
  }

  Future<List<Imigran>> search(String? query) async {
    try {
      final response = await BaseClient()
          .get("/api/imigran?search=$query&per_page=${query == "" ? 5 : 0}");
      response.fold((l) {
        listSearch.value = [];
        throw (l.toString());
      }, (r) {
        List data = r['data'];
        listSearch.value = data.map((e) => Imigran.fromJson(e)).toList();
      });
      return listSearch;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> antarArea(Imigran imigran) async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response =
          await BaseClient().post("/api/imigran/antar-area/${imigran.id}", {
        'id_area': imigran.area?.antarArea?.toArea?.id,
      });
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        await refreshData();
        EasyLoading.showSuccess(
            '${imigran.nama ?? "Data"} berhasil diantar ke ${imigran.area?.antarArea?.toArea?.nama ?? "-"}');
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> terlaksana(Imigran imigran) async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response =
          await BaseClient().post("/api/imigran/terlaksana/${imigran.id}", {
        'terlaksana': 1,
      });
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        await refreshData();
        EasyLoading.showSuccess(
            '${imigran.nama ?? "Data"} berhasil terlaksana');
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> destroy(Imigran imigran) async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response =
          await BaseClient().delete("/api/imigran/destroy/${imigran.id}");
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess("${imigran.nama ?? "Data"} berhasil dihapus");
      });
    } finally {
      EasyLoading.dismiss();
    }
  }
}
