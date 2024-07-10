import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/koordinator.dart';
import 'package:kepulangan/app/services/base_client.dart';

class CreateKoordinatorController extends GetxController {
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
  void onClose() {
    namaController.dispose();
    nipController.dispose();
    statusController.dispose();
    super.onClose();
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
        final response = await BaseClient().post("/api/koordinator/store", {
          'nama': namaController.text,
          'nip': nipController.text,
          'status': statusController.text == 'Aktif' ? 1 : 0,
        });
        response.fold((l) {
          EasyLoading.showError(l.toString());
        }, (r) async {
          final responseData = Koordinator.fromJson(r['data']);
          EasyLoading.showSuccess(
              '${responseData.nama ?? "Koordinator"} berhasil ditambahkan');
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
