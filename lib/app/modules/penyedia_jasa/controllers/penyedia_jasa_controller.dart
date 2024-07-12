import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/penyedia_jasa.dart';
import 'package:kepulangan/app/services/base_client.dart';

class PenyediaJasaController extends GetxController {
  static PenyediaJasaController get to => Get.find();

  var isLoading = false.obs;

  RxList<PenyediaJasa> listPenyediaJasa = <PenyediaJasa>[].obs;

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
    final response = await BaseClient().get("/api/penyedia-jasa");
    response.fold((l) {
      print(l.toString());
      listPenyediaJasa.value = [];
    }, (r) {
      List data = r['data'];
      listPenyediaJasa.value =
          data.map((e) => PenyediaJasa.fromJson(e)).toList();
    });
  }

  Future<void> destroy(PenyediaJasa item) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    try {
      final response =
          await BaseClient().delete("/api/penyedia-jasa/destroy/${item.id}");
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        EasyLoading.showSuccess(
            '${item.namaPerusahaan ?? 'Penyedia Jasa'} berhasil dihapus');
        await getData();
      });
    } finally {
      EasyLoading.dismiss();
    }
  }
}
