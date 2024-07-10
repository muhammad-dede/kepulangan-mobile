import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/koordinator.dart';
import 'package:kepulangan/app/services/base_client.dart';

class EditKoordinatorController extends GetxController {
  Koordinator? koorinator = Get.arguments;

  final formState = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final nipController = TextEditingController();
  final statusController = TextEditingController();

  List listStatus = [
    'Aktif',
    'Tidak Aktif',
  ];

  bool? isLoadingReferensi;

  @override
  void onInit() {
    getEditData();
    super.onInit();
  }

  @override
  void onClose() {
    namaController.dispose();
    nipController.dispose();
    statusController.dispose();
    super.onClose();
  }

  void getEditData() {
    try {
      namaController.text = koorinator?.nama ?? "";
      nipController.text = koorinator?.nip ?? "";
      statusController.text = koorinator?.status == 1 ? 'Aktif' : 'Tidak Aktif';
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  String? validator(String value) {
    if (value.isEmpty) {
      return "Bidang ini wajib diisi";
    }
    return null;
  }

  Future<void> save() async {
    if (formState.currentState!.validate()) {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      try {
        final response = await BaseClient()
            .post("/api/koordinator/update/${koorinator?.id}", {
          'nama': namaController.text,
          'nip': nipController.text,
          'status': statusController.text == 'Aktif' ? 1 : 0,
        });
        response.fold((l) {
          EasyLoading.showError(l.toString());
        }, (r) async {
          final responseData = Koordinator.fromJson(r['data']);
          EasyLoading.showSuccess(
              '${responseData.nama ?? "Koordinator"} berhasil diubah');
          Get.back(result: responseData);
        });
      } finally {
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.showError("Gagal.\nPeriksa kembali inputan Anda");
    }
  }
}
