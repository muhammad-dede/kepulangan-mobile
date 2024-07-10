import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/koordinator.dart';
import 'package:kepulangan/app/services/base_client.dart';

class KoordinatorController extends GetxController {
  static KoordinatorController get to => Get.find();

  var isLoading = false.obs;

  RxList<Koordinator> listKoordinator = <Koordinator>[].obs;

  @override
  void onInit() async {
    await loadData();
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
    final response = await BaseClient().get("/api/koordinator");
    response.fold((l) {
      listKoordinator.value = [];
    }, (r) {
      List data = r['data'];
      listKoordinator.value = data.map((e) => Koordinator.fromJson(e)).toList();
    });
  }

  Future<void> destroy(Koordinator item) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    try {
      final response =
          await BaseClient().delete("/api/koordinator/destroy/${item.id}");
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        EasyLoading.showSuccess('${item.nama ?? "Data"} berhasil dihapus');
        await getData();
      });
    } finally {
      EasyLoading.dismiss();
    }
  }
}
