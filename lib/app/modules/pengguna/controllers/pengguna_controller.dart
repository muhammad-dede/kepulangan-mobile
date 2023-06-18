import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/user.dart';
import 'package:kepulangan/app/services/base_client.dart';

class PenggunaController extends GetxController {
  static PenggunaController get to => Get.find();

  var isLoading = false.obs;

  RxList<User> listPengguna = <User>[].obs;

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
    final response = await BaseClient().get("/api/user");
    response.fold((l) {
      listPengguna.value = [];
    }, (r) {
      List data = r['data'];
      listPengguna.value = data.map((e) => User.fromJson(e)).toList();
    });
  }

  Future<void> destroy(User item) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    try {
      final response =
          await BaseClient().delete("/api/user/destroy/${item.id}");
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
