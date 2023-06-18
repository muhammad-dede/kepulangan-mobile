import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/pihak_kedua.dart';
import 'package:kepulangan/app/services/base_client.dart';

class PihakKeduaController extends GetxController {
  static PihakKeduaController get to => Get.find();

  var isLoading = false.obs;

  RxList<PihakKedua> listPihakKedua = <PihakKedua>[].obs;

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      await getData();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getData() async {
    final response = await BaseClient().get("/api/pihak-kedua");
    response.fold((l) {
      listPihakKedua.value = [];
    }, (r) {
      List data = r['data'];
      listPihakKedua.value = data.map((e) => PihakKedua.fromJson(e)).toList();
    });
  }

  Future<void> destroy(PihakKedua item) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    try {
      final response =
          await BaseClient().delete("/api/pihak-kedua/destroy/${item.id}");
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        EasyLoading.showSuccess(
            '${item.nama ?? 'Pihak Kedua'} berhasil dihapus');
        await getData();
      });
    } finally {
      EasyLoading.dismiss();
    }
  }
}
