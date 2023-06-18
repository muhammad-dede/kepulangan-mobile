import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/pihak_kedua.dart';
import 'package:kepulangan/app/services/base_client.dart';

class CreatePihakKeduaController extends GetxController {
  final formState = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final noIdentitasController = TextEditingController();
  final jabatanController = TextEditingController();
  final instansiController = TextEditingController();
  final alamatController = TextEditingController();
  final noTelpController = TextEditingController();

  @override
  void onClose() {
    namaController.dispose();
    noIdentitasController.dispose();
    jabatanController.dispose();
    instansiController.dispose();
    alamatController.dispose();
    noTelpController.dispose();
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
        final response = await BaseClient().post("/api/pihak-kedua/store", {
          'nama': namaController.text,
          'no_identitas': noIdentitasController.text,
          'jabatan': jabatanController.text,
          'instansi': instansiController.text,
          'alamat': alamatController.text,
          'no_telp': noTelpController.text,
        });
        response.fold((l) {
          EasyLoading.showError(l.toString());
        }, (r) async {
          final responseData = PihakKedua.fromJson(r['data']);
          EasyLoading.showSuccess(
              '${responseData.nama ?? "Pihak Kedua"} berhasil ditambahkan');
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
