import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/penyedia_jasa.dart';
import 'package:kepulangan/app/services/base_client.dart';

class CreatePenyediaJasaController extends GetxController {
  final formState = GlobalKey<FormState>();
  final namaPerusahaanController = TextEditingController();
  final alamatController = TextEditingController();
  final emailController = TextEditingController();
  final noTelpController = TextEditingController();
  final upController = TextEditingController();
  final noPksController = TextEditingController();
  final tanggalPksController = TextEditingController();
  final noDipaController = TextEditingController();
  final tanggalDipaController = TextEditingController();

  DateTime? tanggalPks;
  DateTime? tanggalDipa;

  @override
  void onClose() {
    namaPerusahaanController.dispose();
    alamatController.dispose();
    emailController.dispose();
    noTelpController.dispose();
    upController.dispose();
    noPksController.dispose();
    tanggalPksController.dispose();
    noDipaController.dispose();
    tanggalDipaController.dispose();
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
          'no_pks': noPksController.text,
          'tanggal_pks': DateFormat('yyyy-MM-dd').format(tanggalPks!),
          'no_dipa': noDipaController.text,
          'tanggal_dipa': DateFormat('yyyy-MM-dd').format(tanggalDipa!),
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
