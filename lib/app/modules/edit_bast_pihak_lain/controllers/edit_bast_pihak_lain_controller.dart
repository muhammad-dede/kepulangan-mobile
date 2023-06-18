import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/bast_pihak_lain.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/data/models/jemput_pihak_lain.dart';
import 'package:kepulangan/app/data/models/pihak_kedua.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/services/base_client.dart';

class EditBastPihakLainController extends GetxController {
  BastPihakLain? bastPihakLain = Get.arguments;

  final formState = GlobalKey<FormState>();
  // Rujuk Rs Polri
  PihakKedua? pihakKedua;
  final tanggalSerahTerimaController = TextEditingController();
  DateTime? tanggalSerahTerima;
  File? fotoPihakKedua;
  File? fotoSerahTerima;
  String? fotoPihakKeduaOld;
  String? fotoSerahTerimaOld;
  List<JemputPihakLain>? listJemputPihakLain = <JemputPihakLain>[];

  bool? isLoading;
  List<PihakKedua>? listAllPihakKedua;
  List<PihakKedua>? listPihakKedua;
  List<Imigran>? listAllImigran;
  List<Imigran>? listImigran;

  @override
  void onInit() {
    getEditData();
    super.onInit();
  }

  @override
  void onClose() {
    tanggalSerahTerimaController.dispose();
    super.onClose();
  }

  void getEditData() {
    try {
      pihakKedua = bastPihakLain?.pihakKedua;
      tanggalSerahTerima = bastPihakLain?.tanggalSerahTerima != null
          ? DateTime.parse(bastPihakLain!.tanggalSerahTerima.toString())
          : null;
      tanggalSerahTerimaController.text =
          bastPihakLain?.tanggalSerahTerima != null
              ? DateFormat('dd-MM-yyyy').format(
                  DateTime.parse(bastPihakLain!.tanggalSerahTerima.toString()))
              : "";
      fotoPihakKeduaOld = bastPihakLain?.fotoPihakKedua;
      fotoSerahTerimaOld = bastPihakLain?.fotoSerahTerima;
      for (var jemputPihakLain in bastPihakLain!.jemputPihakLain!) {
        listJemputPihakLain!.add(jemputPihakLain);
      }
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

  Future<void> getPihakKedua() async {
    try {
      isLoading = true;
      final response = await BaseClient().get("/api/pihak-kedua");
      response.fold((l) {
        listAllPihakKedua = [];
        listPihakKedua = [];
      }, (r) {
        List data = r['data'];
        listAllPihakKedua = data.map((e) => PihakKedua.fromJson(e)).toList();
        listPihakKedua = data.map((e) => PihakKedua.fromJson(e)).toList();
      });
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getImigran() async {
    try {
      isLoading = true;
      final response = await BaseClient().get(
          "/api/imigran?id_kepulangan=6&id_bast_pihak_lain=${bastPihakLain?.id}&terlaksana=false");
      response.fold((l) {
        listAllImigran = [];
        listImigran = [];
      }, (r) {
        List data = r['data'];
        listAllImigran = data.map((e) => Imigran.fromJson(e)).toList();
        listImigran = data.map((e) => Imigran.fromJson(e)).toList();
      });
    } finally {
      isLoading = false;
      update();
    }
  }

  void getFotoPihakKedua(ImageSource imageSource) async {
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
      fotoPihakKedua = File(compressImage!.path);
    } catch (e) {
      EasyLoading.showError(e.toString());
      fotoPihakKedua = null;
    } finally {
      update();
    }
  }

  void getFotoSerahTerima(ImageSource imageSource) async {
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
      fotoSerahTerima = File(compressImage!.path);
    } catch (e) {
      EasyLoading.showError(e.toString());
      fotoSerahTerima = null;
    } finally {
      update();
    }
  }

  Future<void> save() async {
    if (formState.currentState!.validate()) {
      if (pihakKedua == null) {
        EasyLoading.showError("Data Pihak Kedua wajib diisi");
        return;
      }
      try {
        EasyLoading.show(
            status: 'loading...', maskType: EasyLoadingMaskType.black);
        Map<String, dynamic> data;
        data = {
          'id_pihak_kedua': pihakKedua?.id,
          'tanggal_serah_terima':
              DateFormat('yyyy-MM-dd').format(tanggalSerahTerima!),
          'foto_pihak_kedua': fotoPihakKedua ?? "",
          'foto_serah_terima': fotoSerahTerima ?? "",
        };
        if (listJemputPihakLain!.isNotEmpty) {
          for (var i = 0; i < listJemputPihakLain!.length; i++) {
            var item = listJemputPihakLain![i];
            data.addAll({
              "jemput_pihak_lain[$i][id_imigran]": item.imigran?.id,
            });
          }
        }
        final response = await BaseClient().postMultipart(
            "/api/bast-pihak-lain/update/${bastPihakLain?.id}", data);
        response.fold((l) {
          EasyLoading.showError(l.toString());
        }, (r) async {
          final responseData = BastPihakLain.fromJson(r['data']);
          MainController.to.generateRefreshKey(10);
          EasyLoading.showSuccess(
              "${responseData.pihakKedua?.nama ?? "Data"} berhasil disimpan");
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
