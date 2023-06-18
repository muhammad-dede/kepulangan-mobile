import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/alamat.dart';
import 'package:kepulangan/app/modules/alamat/controllers/alamat_controller.dart';
import 'package:kepulangan/app/services/base_client.dart';

class EditAlamatController extends GetxController {
  Alamat? alamat = Get.arguments;

  final formState = GlobalKey<FormState>();
  final judulController = TextEditingController();
  final lokasiController = TextEditingController();
  bool utama = false;

  @override
  void onInit() {
    getEditData();
    super.onInit();
  }

  @override
  void onClose() {
    judulController.dispose();
    lokasiController.dispose();
    super.onClose();
  }

  void getEditData() {
    try {
      judulController.text = alamat?.judul ?? "";
      lokasiController.text = alamat?.lokasi ?? "";
      utama = alamat?.utama == 1 ? true : false;
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
        final response =
            await BaseClient().post("/api/alamat/update/${alamat?.id}", {
          'judul': judulController.text,
          'lokasi': lokasiController.text,
          'utama': utama,
        });
        response.fold((l) {
          EasyLoading.showError(l.toString());
        }, (r) async {
          final responseData = Alamat.fromJson(r['data']);
          EasyLoading.showSuccess(
              '${responseData.judul ?? ""} berhasil disimpan');
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
