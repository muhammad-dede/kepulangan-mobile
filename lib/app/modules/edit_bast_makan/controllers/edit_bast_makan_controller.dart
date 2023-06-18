import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/alamat.dart';
import 'package:kepulangan/app/data/models/bast_makan.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/data/models/makan.dart';
import 'package:kepulangan/app/data/models/penyedia_jasa.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/services/base_client.dart';

class EditBastMakanController extends GetxController {
  BastMakan? bastMakan = Get.arguments;

  final formState = GlobalKey<FormState>();
  final purchaseOrderController = TextEditingController();
  final penyediaJasaController = TextEditingController();
  final alamatController = TextEditingController();
  final durasiPengerjaanController = TextEditingController();
  final tanggalSerahTerimaController = TextEditingController();
  final waktuSerahTerimaController = TextEditingController();

  int? idPenyediaJasa;
  int? idAlamat;
  int? durasiPengerjaan;
  DateTime? tanggalSerahTerima;
  File? fotoPenyediaJasa;
  File? fotoSerahTerima;
  File? fotoInvoice;
  String? fotoPenyediaJasaOld;
  String? fotoSerahTerimaOld;
  String? fotoInvoiceOld;

  List<Makan>? listMakan = <Makan>[];

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
      "title": "${index + 1} hari pengerjaan",
      "value": int.parse((index + 1).toString()),
    };
  });

  List<Map<String, dynamic>> listWaktuSerahTerima = [
    {"value": "07:00"},
    {"value": "13:00"},
    {"value": "19:00"},
  ];

  @override
  void onInit() {
    getEdit();
    super.onInit();
  }

  @override
  void onClose() {
    purchaseOrderController.dispose();
    penyediaJasaController.dispose();
    alamatController.dispose();
    durasiPengerjaanController.dispose();
    tanggalSerahTerimaController.dispose();
    waktuSerahTerimaController.dispose();
    super.onClose();
  }

  void getEdit() {
    try {
      purchaseOrderController.text = bastMakan?.purchaseOrder ?? "";
      penyediaJasaController.text =
          bastMakan?.penyediaJasa?.namaPerusahaan ?? "";
      idPenyediaJasa = bastMakan?.penyediaJasa?.id;
      alamatController.text = bastMakan?.alamat?.judul ?? "";
      idAlamat = bastMakan?.alamat?.id;
      durasiPengerjaanController.text = bastMakan?.durasiPengerjaan != null
          ? "${bastMakan?.durasiPengerjaan.toString()} hari pengerjaan"
          : "";
      durasiPengerjaan = bastMakan?.durasiPengerjaan;
      tanggalSerahTerima = bastMakan?.tanggalSerahTerima != null
          ? DateTime.parse(bastMakan!.tanggalSerahTerima.toString())
          : null;
      tanggalSerahTerimaController.text = bastMakan?.tanggalSerahTerima != null
          ? DateFormat('dd-MM-yyyy')
              .format(DateTime.parse(bastMakan!.tanggalSerahTerima.toString()))
          : "";
      waktuSerahTerimaController.text = bastMakan?.waktuSerahTerima ?? "";
      fotoPenyediaJasaOld = bastMakan?.fotoPenyediaJasa;
      fotoSerahTerimaOld = bastMakan?.fotoSerahTerima;
      fotoInvoiceOld = bastMakan?.fotoInvoice;
      for (var makan in bastMakan!.makan!) {
        listMakan!.add(makan);
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
          "/api/imigran?id_kepulangan=1&id_bast_makan=${bastMakan?.id}&terlaksana=false");
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

  void getFotoInvoice(ImageSource imageSource) async {
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
      fotoInvoice = File(compressImage!.path);
    } catch (e) {
      EasyLoading.showError(e.toString());
      fotoInvoice = null;
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
          'waktu_serah_terima': waktuSerahTerimaController.text,
          'foto_penyedia_jasa': fotoPenyediaJasa ?? "",
          'foto_serah_terima': fotoSerahTerima ?? "",
          'foto_invoice': fotoInvoice ?? "",
        };
        if (listMakan!.isNotEmpty) {
          for (var i = 0; i < listMakan!.length; i++) {
            var item = listMakan![i];
            data.addAll({
              "makan[$i][id_imigran]": item.imigran?.id,
            });
          }
        }
        final response = await BaseClient()
            .postMultipart("/api/bast-makan/update/${bastMakan?.id}", data);
        response.fold((l) {
          EasyLoading.showError(l.toString());
        }, (r) async {
          final responseData = BastMakan.fromJson(r['data']);
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
