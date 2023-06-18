import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/alamat.dart';
import 'package:kepulangan/app/modules/alamat/controllers/alamat_controller.dart';
import 'package:kepulangan/app/services/base_client.dart';

class CreateAlamatController extends GetxController {
  final formState = GlobalKey<FormState>();
  final judulController = TextEditingController();
  final lokasiController = TextEditingController();
  bool utama = false;

  @override
  void onClose() {
    judulController.dispose();
    lokasiController.dispose();
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
      try {
        EasyLoading.show(
            status: 'loading...', maskType: EasyLoadingMaskType.black);
        final response = await BaseClient().post("/api/alamat/store", {
          'judul': judulController.text,
          'lokasi': lokasiController.text,
          'utama': utama,
        });
        response.fold((l) {
          EasyLoading.showError(l.toString());
        }, (r) async {
          final responseData = Alamat.fromJson(r['data']);
          EasyLoading.showSuccess(
              '${responseData.judul ?? ""} berhasil ditambahkan');
          await AlamatController.to.getData();
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
