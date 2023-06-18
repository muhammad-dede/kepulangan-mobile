import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/alamat.dart';
import 'package:kepulangan/app/data/models/bast_udara.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/data/models/penyedia_jasa.dart';
import 'package:kepulangan/app/data/models/udara.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/services/base_client.dart';

class CreateBastUdaraController extends GetxController {
  final formState = GlobalKey<FormState>();

  final purchaseOrderController = TextEditingController();
  final penyediaJasaController = TextEditingController();
  final alamatController = TextEditingController();
  final durasiPengerjaanController = TextEditingController();
  final tanggalSerahTerimaController = TextEditingController();

  int? idPenyediaJasa;
  int? idAlamat;
  int? durasiPengerjaan;
  DateTime? tanggalSerahTerima;
  File? fotoPenyediaJasa;
  File? fotoSerahTerima;
  List<Udara>? listUdara = <Udara>[];

  bool? isLoading;
  List<PenyediaJasa>? listAllPenyediaJasa;
  List<PenyediaJasa>? listPenyediaJasa;
  List<Alamat>? listAllAlamat;
  List<Alamat>? listAlamat;
  List<Imigran>? listAllImigran;
  List<Imigran>? listImigran;

  List<Map<String, dynamic>> listDurasiPengerjaan =
      List<Map<String, dynamic>>.generate(100, (index) {
    return {
      "value": int.parse((index + 1).toString()),
      "durasi": "${index + 1} hari pengerjaan",
    };
  });

  @override
  void onClose() {
    purchaseOrderController.dispose();
    penyediaJasaController.dispose();
    alamatController.dispose();
    durasiPengerjaanController.dispose();
    tanggalSerahTerimaController.dispose();
    super.onClose();
  }

  String? validator(String value) {
    if (value.isEmpty) {
      return "Bidang ini wajib diisi";
    }
    return null;
  }

  Future<void> getPenyediaJasa() async {
    try {
      isLoading = true;
      final response = await BaseClient().get("/api/penyedia-jasa");
      response.fold((l) {
        listAllPenyediaJasa = [];
        listPenyediaJasa = [];
      }, (r) {
        List data = r['data'];
        listAllPenyediaJasa =
            data.map((e) => PenyediaJasa.fromJson(e)).toList();
        listPenyediaJasa = data.map((e) => PenyediaJasa.fromJson(e)).toList();
      });
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getAlamat() async {
    try {
      isLoading = true;
      final response = await BaseClient().get("/api/alamat");
      response.fold((l) {
        listAllAlamat = [];
        listAlamat = [];
      }, (r) {
        List data = r['data'];
        listAllAlamat = data.map((e) => Alamat.fromJson(e)).toList();
        listAlamat = data.map((e) => Alamat.fromJson(e)).toList();
      });
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getImigran() async {
    try {
      isLoading = true;
      final response = await BaseClient()
          .get("/api/imigran?id_kepulangan=2&terlaksana=false");
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

  void getFotoPenyediaJasa(ImageSource imageSource) async {
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
      fotoPenyediaJasa = File(compressImage!.path);
    } catch (e) {
      EasyLoading.showError(e.toString());
      fotoPenyediaJasa = null;
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

  void getFotoBoardingPass(ImageSource imageSource, Imigran item) async {
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
      listUdara!
          .where((element) => element.imigran?.id == item.id)
          .first
          .fotoBoardingPassFile = File(compressImage!.path);
    } catch (e) {
      EasyLoading.showError(e.toString());
      listUdara!
          .where((element) => element.imigran?.id == item.id)
          .first
          .fotoBoardingPassFile = null;
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
          'purchase_order': purchaseOrderController.text,
          'id_penyedia_jasa': idPenyediaJasa,
          'id_alamat': idAlamat,
          'durasi_pengerjaan': durasiPengerjaan,
          'tanggal_serah_terima':
              DateFormat('yyyy-MM-dd').format(tanggalSerahTerima!),
          'foto_penyedia_jasa': fotoPenyediaJasa ?? "",
          'foto_serah_terima': fotoSerahTerima ?? "",
        };
        if (listUdara!.isNotEmpty) {
          for (var i = 0; i < listUdara!.length; i++) {
            var item = listUdara![i];
            data.addAll({
              "udara[$i][id_imigran]": item.imigran?.id,
              "udara[$i][foto_boarding_pass]": item.fotoBoardingPassFile ?? "",
            });
          }
        }
        final response =
            await BaseClient().postMultipart("/api/bast-udara/store", data);
        response.fold((l) {
          EasyLoading.showError(l.toString());
        }, (r) async {
          final responseData = BastUdara.fromJson(r['data']);
          MainController.to.generateRefreshKey(10);
          EasyLoading.showSuccess(
              "${responseData.purchaseOrder ?? "Data"} berhasil ditambahkan");
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
