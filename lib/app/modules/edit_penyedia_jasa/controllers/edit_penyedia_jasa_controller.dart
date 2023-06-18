import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/penyedia_jasa.dart';
import 'package:kepulangan/app/services/base_client.dart';

class EditPenyediaJasaController extends GetxController {
  PenyediaJasa? penyediaJasa = Get.arguments;

  final formState = GlobalKey<FormState>();
  final namaPerusahaanController = TextEditingController();
  final alamatController = TextEditingController();
  final emailController = TextEditingController();
  final noTelpController = TextEditingController();
  final upController = TextEditingController();

  @override
  void onInit() {
    getEditData();
    super.onInit();
  }

  @override
  void onClose() {
    namaPerusahaanController.dispose();
    alamatController.dispose();
    emailController.dispose();
    noTelpController.dispose();
    upController.dispose();
    super.onClose();
  }

  void getEditData() {
    try {
      namaPerusahaanController.text = penyediaJasa?.namaPerusahaan ?? "";
      alamatController.text = penyediaJasa?.alamat ?? "";
      emailController.text = penyediaJasa?.email ?? "";
      noTelpController.text = penyediaJasa?.noTelp ?? "";
      upController.text = penyediaJasa?.up ?? "";
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
      try {
        EasyLoading.show(
            status: 'loading...', maskType: EasyLoadingMaskType.black);
        final response = await BaseClient()
            .post("/api/penyedia-jasa/update/${penyediaJasa?.id}", {
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
              '${responseData.namaPerusahaan ?? "Penyedia Jasa"} berhasil disimpan');
          Get.back(result: responseData);
        });
      } finally {
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.showError('Gagal.\nPeriksa kembali inputan Anda');
    }
  }
}
