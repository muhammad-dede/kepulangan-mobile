import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/alamat.dart';
import 'package:kepulangan/app/services/base_client.dart';

class AlamatController extends GetxController {
  static AlamatController get to => Get.find();

  var isLoading = false.obs;

  RxList<Alamat> listAlamat = <Alamat>[].obs;

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
    final response = await BaseClient().get("/api/alamat");
    response.fold((l) {
      listAlamat.value = [];
    }, (r) async {
      List data = r['data'];
      listAlamat.value = data.map((e) => Alamat.fromJson(e)).toList();
    });
  }

  Future<void> destroy(Alamat item) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    try {
      final response =
          await BaseClient().delete("/api/alamat/destroy/${item.id}");
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        await getData();
        EasyLoading.showSuccess('${item.judul ?? "Data"} berhasil dihapus');
      });
    } finally {
      EasyLoading.dismiss();
    }
  }
}
