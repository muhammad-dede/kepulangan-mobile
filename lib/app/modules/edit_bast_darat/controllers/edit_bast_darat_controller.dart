import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/alamat.dart';
import 'package:kepulangan/app/data/models/bast_darat.dart';
import 'package:kepulangan/app/data/models/darat.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/data/models/penyedia_jasa.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/services/base_client.dart';

class EditBastDaratController extends GetxController {
  BastDarat? bastDarat = Get.arguments;

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
  List<Darat>? listDarat = <Darat>[];

  String? fotoPenyediaJasaOld;
  String? fotoSerahTerimaOld;

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
  void onInit() async {
    getEditData();
    super.onInit();
  }

  @override
  void onClose() {
    purchaseOrderController.dispose();
    penyediaJasaController.dispose();
    alamatController.dispose();
    durasiPengerjaanController.dispose();
    tanggalSerahTerimaController.dispose();
    super.onClose();
  }

  void getEditData() {
    try {
      purchaseOrderController.text = bastDarat?.purchaseOrder ?? "";
      penyediaJasaController.text =
          bastDarat?.penyediaJasa?.namaPerusahaan ?? "";
      idPenyediaJasa = bastDarat?.penyediaJasa?.id;
      alamatController.text = bastDarat?.alamat?.judul ?? "";
      idAlamat = bastDarat?.alamat?.id;
      durasiPengerjaanController.text = bastDarat?.durasiPengerjaan != null
          ? "${bastDarat?.durasiPengerjaan.toString()} hari pengerjaan"
          : "";
      durasiPengerjaan = bastDarat?.durasiPengerjaan;
      tanggalSerahTerima = bastDarat?.tanggalSerahTerima != null
          ? DateTime.parse(bastDarat!.tanggalSerahTerima.toString())
          : null;
      tanggalSerahTerimaController.text = bastDarat?.tanggalSerahTerima != null
          ? DateFormat('dd-MM-yyyy')
              .format(DateTime.parse(bastDarat!.tanggalSerahTerima.toString()))
          : "";
      fotoPenyediaJasaOld = bastDarat?.fotoPenyediaJasa;
      fotoSerahTerimaOld = bastDarat?.fotoSerahTerima;
      for (var darat in bastDarat!.darat!) {
        listDarat!.add(darat);
      }
    } catch (e) {
      EasyLoading.showError(e.toString());
    } finally {
      update();
    }
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
      final response = await BaseClient().get(
          "/api/imigran?id_kepulangan=1&id_bast_darat=${bastDarat?.id}&terlaksana=false");
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

  void getFotoBast(ImageSource imageSource, Imigran item) async {
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
      listDarat!
          .where((element) => element.imigran?.id == item.id)
          .first
          .fotoBastFile = File(compressImage!.path);
    } catch (e) {
      EasyLoading.showError(e.toString());
      listDarat!
          .where((element) => element.imigran?.id == item.id)
          .first
          .fotoBastFile = null;
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
        if (listDarat!.isNotEmpty) {
          for (var i = 0; i < listDarat!.length; i++) {
            var item = listDarat![i];
            data.addAll({
              "darat[$i][id_imigran]": item.imigran?.id,
              "darat[$i][foto_bast]": item.fotoBastFile ?? "",
            });
          }
        }
        final response = await BaseClient()
            .postMultipart("/api/bast-darat/update/${bastDarat?.id}", data);
        response.fold((l) {
          EasyLoading.showError(l.toString());
        }, (r) async {
          final responseData = BastDarat.fromJson(r['data']);
          MainController.to.generateRefreshKey(10);
          EasyLoading.showSuccess(
              "${responseData.purchaseOrder ?? "Data"} berhasil disimpan");
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
