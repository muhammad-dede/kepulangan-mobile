import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/penyedia_jasa.dart';
import 'package:kepulangan/app/services/base_client.dart';

class CreatePenyediaJasaController extends GetxController {
  final formState = GlobalKey<FormState>();
  final namaPerusahaanController = TextEditingController();
  final alamatController = TextEditingController();
  final emailController = TextEditingController();
  final noTelpController = TextEditingController();
  final upController = TextEditingController();

  @override
  void onClose() {
    namaPerusahaanController.dispose();
    alamatController.dispose();
    emailController.dispose();
    noTelpController.dispose();
    upController.dispose();
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
        final response = await BaseClient().post("/api/penyedia-jasa/store", {
          'nama_perusahaan': namaPerusahaanController.text,
          'alamat': alamatController.text,
          'email': emailController.text,
          'no_telp': noTelpController.text,
          'up': upController.text,
        });
        response.fold((l) {
          EasyLoading.showError(l.toString());
        }, (r) async {
          final responseData = PenyediaJasa.fromJson(r['data']);
          EasyLoading.showSuccess(
              '${responseData.namaPerusahaan ?? "Penyedia Jasa"} berhasil ditambahkan');
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
