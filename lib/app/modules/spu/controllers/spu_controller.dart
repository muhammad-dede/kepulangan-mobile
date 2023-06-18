import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/bast_udara.dart';
import 'package:kepulangan/app/data/models/provinsi.dart';
import 'package:kepulangan/app/data/models/spu_tiket.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/services/base_client.dart';

class SpuController extends GetxController {
  static SpuController get to => Get.find();

  BastUdara? bastUdara = Get.arguments;

  final formState = GlobalKey<FormState>();
  final noSuratController = TextEditingController();
  final tanggalSuratController = TextEditingController();
  final provinsiController = TextEditingController();
  final noPesawatController = TextEditingController();
  final jamPesawatController = TextEditingController();
  final tanggalPesawatController = TextEditingController();

  DateTime? tanggalSurat;
  int? idProvinsi;
  DateTime? tanggalPesawat;
  List<SpuTiket>? listSpuTiket = <SpuTiket>[];

  bool? isLoading;
  List<Provinsi>? listAllProvinsi;
  List<Provinsi>? listProvinsi;

  @override
  void onInit() {
    getCreateOrEdit();
    super.onInit();
  }

  @override
  void onClose() {
    noSuratController.dispose();
    tanggalSuratController.dispose();
    provinsiController.dispose();
    noPesawatController.dispose();
    jamPesawatController.dispose();
    tanggalPesawatController.dispose();
    super.onClose();
  }

  void getCreateOrEdit() {
    noSuratController.text = bastUdara?.spu?.noSurat ?? "";
    tanggalSuratController.text = bastUdara?.spu?.tanggalSurat != null
        ? DateFormat('dd-MM-yyyy')
            .format(DateTime.parse(bastUdara!.spu!.tanggalSurat.toString()))
            .toString()
        : "";
    provinsiController.text = bastUdara?.spu?.provinsi?.nama ?? "";
    noPesawatController.text = bastUdara?.spu?.noPesawat ?? "";
    jamPesawatController.text = bastUdara?.spu?.jamPesawat ?? "";
    tanggalPesawatController.text = bastUdara?.spu?.tanggalPesawat != null
        ? DateFormat('dd-MM-yyyy')
            .format(DateTime.parse(bastUdara!.spu!.tanggalPesawat.toString()))
            .toString()
        : "";
    tanggalSurat = bastUdara?.spu?.tanggalSurat != null
        ? DateTime.parse(bastUdara!.spu!.tanggalSurat.toString())
        : null;
    idProvinsi = bastUdara?.spu?.provinsi?.id;
    tanggalPesawat = bastUdara?.spu?.tanggalPesawat != null
        ? DateTime.parse(bastUdara!.spu!.tanggalPesawat.toString())
        : null;

    if (bastUdara?.spu?.spuTiket != null) {
      for (var spuTiket in bastUdara!.spu!.spuTiket!) {
        listSpuTiket!.add(spuTiket);
      }
    }
  }

  String? validator(String value) {
    if (value.isEmpty) {
      return "Bidang ini wajib diisi";
    }
    return null;
  }

  Future<void> getProvinsi() async {
    try {
      isLoading = true;
      final response = await BaseClient().get("/api/referensi/provinsi");
      response.fold((l) {
        listAllProvinsi = [];
        listProvinsi = [];
      }, (r) {
        List data = r['data'];
        listAllProvinsi = data.map((e) => Provinsi.fromJson(e)).toList();
        listProvinsi = data.map((e) => Provinsi.fromJson(e)).toList();
      });
    } finally {
      isLoading = false;
      update();
    }
  }

  void getFotoTiket(ImageSource imageSource) async {
    try {
      var pickedImage = await ImagePicker().pickImage(source: imageSource);
      if (pickedImage == null) {
        return;
      }
      var compressImage = await FlutterImageCompress.compressAndGetFile(
        pickedImage.path,
        '${pickedImage.path}${DateTime.now()}.jpg',
        quality: 50,
      );
      listSpuTiket?.add(SpuTiket(fotoTiketFile: File(compressImage!.path)));
    } catch (e) {
      EasyLoading.showError(e.toString());
    } finally {
      update();
    }
  }

  Future<void> save() async {
    if (formState.currentState!.validate()) {
      try {
        EasyLoading.show(
            status: 'loading...', maskType: EasyLoadingMaskType.black);
        Map<String, dynamic> data;
        data = {
          'no_surat': noSuratController.text,
          'tanggal_surat': DateFormat('yyyy-MM-dd').format(tanggalSurat!),
          'id_provinsi': idProvinsi,
          'no_pesawat': noPesawatController.text,
          'jam_pesawat': jamPesawatController.text,
          'tanggal_pesawat': DateFormat('yyyy-MM-dd').format(tanggalPesawat!),
        };
        if (listSpuTiket!.isNotEmpty) {
          for (var i = 0; i < listSpuTiket!.length; i++) {
            var item = listSpuTiket![i];
            data.addAll({
              "spu_tiket[$i][foto_tiket]": item.fotoTiketFile ?? "",
              "spu_tiket[$i][foto_tiket_url]": item.fotoTiket ?? "",
            });
          }
        }
        final response = await BaseClient()
            .postMultipart("/api/bast-udara/spu/${bastUdara?.id}", data);
        response.fold((l) {
          EasyLoading.showError(l.toString());
        }, (r) async {
          final responseData = BastUdara.fromJson(r['data']);
          MainController.to.generateRefreshKey(10);
          EasyLoading.showSuccess(
              "${responseData.purchaseOrder ?? "Surat Petintah Udara"} berhasil disimpan");
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
