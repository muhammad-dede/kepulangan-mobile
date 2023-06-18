import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/bast_darat.dart';
import 'package:kepulangan/app/data/models/bast_pihak_lain.dart';
import 'package:kepulangan/app/data/models/bast_udara.dart';
import 'package:kepulangan/app/data/models/kepulangan.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/data/models/pihak_kedua.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/services/base_client.dart';

class KepulanganController extends GetxController {
  Imigran? imigran = Get.arguments[0]['imigran'];
  Kepulangan? kepulangan = Get.arguments[1]['kepulangan'];

  bool? isDarat;
  bool? isUdara;
  bool? isRujukRsPolri;
  bool? isPulangMandiri;
  bool? isJemputKeluarga;
  bool? isJemputPihakLain;

  bool? isLoading;

  final formState = GlobalKey<FormState>();
  // Darat
  BastDarat? bastDarat;
  File? fotoBast;
  String? fotoBastOld;
  List<BastDarat>? listAllBastDarat;
  List<BastDarat>? listBastDarat;
  // Udara
  BastUdara? bastUdara;
  File? fotoBoardingPass;
  String? fotoBoardingPassOld;
  List<BastUdara>? listAllBastUdara;
  List<BastUdara>? listBastUdara;
  // Rujuk Rs Polri
  PihakKedua? pihakKedua;
  File? fotoPihakKedua;
  String? fotoPihakKeduaOld;
  List<PihakKedua>? listAllPihakKedua;
  List<PihakKedua>? listPihakKedua;
  // Pulang Mandiri only tanggal serah terima & foto serah terima
  // Jemput Keluarga
  final namaPenjemputController = TextEditingController();
  final hubunganDenganPmiController = TextEditingController();
  final noTelpPenjemputController = TextEditingController();
  File? fotoPenjemput;
  String? fotoPenjemputOld;
  // Jemput Pihak Lain
  BastPihakLain? bastPihakLain;
  List<BastPihakLain>? listAllBastPihakLain;
  List<BastPihakLain>? listBastPihakLain;

  // For All
  final tanggalSerahTerimaController = TextEditingController();
  DateTime? tanggalSerahTerima;
  File? fotoSerahTerima;
  String? fotoSerahTerimaOld;

  @override
  void onInit() async {
    isDarat = kepulangan?.id == 1 ? true : false;
    isUdara = kepulangan?.id == 2 ? true : false;
    isRujukRsPolri = kepulangan?.id == 3 ? true : false;
    isPulangMandiri = kepulangan?.id == 4 ? true : false;
    isJemputKeluarga = kepulangan?.id == 5 ? true : false;
    isJemputPihakLain = kepulangan?.id == 6 ? true : false;
    getCreateOrUpdateData();
    super.onInit();
  }

  @override
  void onClose() {
    namaPenjemputController.dispose();
    hubunganDenganPmiController.dispose();
    noTelpPenjemputController.dispose();
    tanggalSerahTerimaController.dispose();
    super.onClose();
  }

  void getCreateOrUpdateData() {
    try {
      if (isDarat == true) {
        bastDarat = imigran?.darat?.bastDarat;
        fotoBastOld = imigran?.darat?.fotoBast;
      }
      if (isUdara == true) {
        bastUdara = imigran?.udara?.bastUdara;
        fotoBoardingPassOld = imigran?.udara?.fotoBoardingPass;
      }
      if (isRujukRsPolri == true) {
        pihakKedua = imigran?.rujukRsPolri?.pihakKedua;
        tanggalSerahTerimaController.text =
            imigran?.rujukRsPolri?.tanggalSerahTerima != null
                ? DateFormat('dd-MM-yyyy')
                    .format(DateTime.parse(
                        imigran!.rujukRsPolri!.tanggalSerahTerima.toString()))
                    .toString()
                : "";
        tanggalSerahTerima = imigran?.rujukRsPolri?.tanggalSerahTerima != null
            ? DateTime.parse(
                imigran!.rujukRsPolri!.tanggalSerahTerima.toString())
            : null;
        fotoPihakKeduaOld = imigran?.rujukRsPolri?.fotoPihakKedua;
        fotoSerahTerimaOld = imigran?.rujukRsPolri?.fotoSerahTerima;
      }
      if (isPulangMandiri == true) {
        tanggalSerahTerimaController.text =
            imigran?.pulangMandiri?.tanggalSerahTerima != null
                ? DateFormat('dd-MM-yyyy')
                    .format(DateTime.parse(
                        imigran!.pulangMandiri!.tanggalSerahTerima.toString()))
                    .toString()
                : "";
        tanggalSerahTerima = imigran?.pulangMandiri?.tanggalSerahTerima != null
            ? DateTime.parse(
                imigran!.pulangMandiri!.tanggalSerahTerima.toString())
            : null;
        fotoSerahTerimaOld = imigran?.pulangMandiri?.fotoSerahTerima;
      }
      if (isJemputKeluarga == true) {
        namaPenjemputController.text =
            imigran?.jemputKeluarga?.namaPenjemput ?? "";
        hubunganDenganPmiController.text =
            imigran?.jemputKeluarga?.hubunganDenganPmi ?? "";
        noTelpPenjemputController.text =
            imigran?.jemputKeluarga?.noTelpPenjemput ?? "";
        tanggalSerahTerimaController.text =
            imigran?.jemputKeluarga?.tanggalSerahTerima != null
                ? DateFormat('dd-MM-yyyy')
                    .format(DateTime.parse(
                        imigran!.jemputKeluarga!.tanggalSerahTerima.toString()))
                    .toString()
                : "";
        tanggalSerahTerima = imigran?.jemputKeluarga?.tanggalSerahTerima != null
            ? DateTime.parse(
                imigran!.jemputKeluarga!.tanggalSerahTerima.toString())
            : null;
        fotoPenjemputOld = imigran?.jemputKeluarga?.fotoPenjemput;
        fotoSerahTerimaOld = imigran?.jemputKeluarga?.fotoSerahTerima;
      }
      if (isJemputPihakLain == true) {
        bastPihakLain = imigran?.jemputPihakLain?.bastPihakLain;
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

  void getFotoBast(ImageSource imageSource) async {
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
      fotoBast = File(compressImage!.path);
    } catch (e) {
      EasyLoading.showError(e.toString());
      fotoBast = null;
    } finally {
      update();
    }
  }

  void getFotoBoardingPass(ImageSource imageSource) async {
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
      fotoBoardingPass = File(compressImage!.path);
    } catch (e) {
      EasyLoading.showError(e.toString());
      fotoBoardingPass = null;
    } finally {
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

  void getFotoPenjemput(ImageSource imageSource) async {
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
      fotoPenjemput = File(compressImage!.path);
    } catch (e) {
      EasyLoading.showError(e.toString());
      fotoPenjemput = null;
    } finally {
      update();
    }
  }

  Future<void> getBastDarat() async {
    try {
      isLoading = true;
      final response = await BaseClient().get("/api/bast-darat?terlaksana=0");
      response.fold((l) {
        listAllBastDarat = [];
        listBastDarat = [];
        throw (l.toString());
      }, (r) {
        List data = r['data'];
        listAllBastDarat = data.map((e) => BastDarat.fromJson(e)).toList();
        listBastDarat = data.map((e) => BastDarat.fromJson(e)).toList();
      });
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getBastUdara() async {
    try {
      isLoading = true;
      final response = await BaseClient().get("/api/bast-udara?terlaksana=0");
      response.fold((l) {
        listAllBastUdara = [];
        listBastUdara = [];
        throw (l.toString());
      }, (r) {
        List data = r['data'];
        listAllBastUdara = data.map((e) => BastUdara.fromJson(e)).toList();
        listBastUdara = data.map((e) => BastUdara.fromJson(e)).toList();
      });
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getPihakKedua() async {
    try {
      isLoading = true;
      final response = await BaseClient().get("/api/pihak-kedua");
      response.fold((l) {
        listAllPihakKedua = [];
        listPihakKedua = [];
        throw (l.toString());
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

  Future<void> getBastPihakLain() async {
    try {
      isLoading = true;
      final response =
          await BaseClient().get("/api/bast-pihak-lain?terlaksana=0");
      response.fold((l) {
        listAllBastPihakLain = [];
        listBastPihakLain = [];
        throw (l.toString());
      }, (r) {
        List data = r['data'];
        listAllBastPihakLain =
            data.map((e) => BastPihakLain.fromJson(e)).toList();
        listBastPihakLain = data.map((e) => BastPihakLain.fromJson(e)).toList();
      });
    } finally {
      isLoading = false;
      update();
    }
  }

  void save() async {
    if (formState.currentState!.validate()) {
      if (isDarat == true) {
        if (bastDarat == null) {
          EasyLoading.showError("Data Fasilitas Darat wajib diisi");
          return;
        }
        if (fotoBast == null && fotoBastOld == null) {
          EasyLoading.showError("Foto Bast wajib diisi");
          return;
        }
        await saveDarat();
      }
      if (isUdara == true) {
        if (bastUdara == null) {
          EasyLoading.showError("Data Fasilitas Udara wajib diisi");
          return;
        }
        if (fotoBoardingPass == null && fotoBoardingPassOld == null) {
          EasyLoading.showError("Foto Boarding Pass wajib diisi");
          return;
        }
        await saveUdara();
      }
      if (isRujukRsPolri == true) {
        if (pihakKedua == null) {
          EasyLoading.showError("Data Pihak Kedua wajib diisi");
          return;
        }
        if (fotoPihakKedua == null && fotoPihakKeduaOld == null) {
          EasyLoading.showError("Foto Pihak Kedua wajib diisi");
          return;
        }
        if (fotoSerahTerima == null && fotoSerahTerimaOld == null) {
          EasyLoading.showError("Foto Serah Terima wajib diisi");
          return;
        }
        await saveRujukRsPolri();
      }

      if (isPulangMandiri == true) {
        if (fotoSerahTerima == null && fotoSerahTerimaOld == null) {
          EasyLoading.showError("Foto Serah terima wajib diisi");
          return;
        }
        await savePulangMandiri();
      }
      if (isJemputKeluarga == true) {
        if (fotoPenjemput == null && fotoPenjemputOld == null) {
          EasyLoading.showError("Foto Penjemput wajib diisi");
          return;
        }
        if (fotoSerahTerima == null && fotoSerahTerimaOld == null) {
          EasyLoading.showError("Foto Serah Terima wajib diisi");
          return;
        }
        await saveJemputKeluarga();
      }
      if (isJemputPihakLain == true) {
        if (bastPihakLain == null) {
          EasyLoading.showError("Data Pihak Kedua wajib diisi");
          return;
        }
        await saveJemputPihakLain();
      }
    } else {
      EasyLoading.showError('Gagal.\nPeriksa kembali inputan Anda');
    }
  }

  Future<void> saveDarat() async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response = await BaseClient()
          .postMultipart("/api/imigran/kepulangan/${imigran?.id}", {
        'id_kepulangan': kepulangan?.id,
        "id_bast_darat": bastDarat?.id,
        'foto_bast': fotoBast ?? "",
      });
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        final responseData = Imigran.fromJson(r['data']);
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            'Kepulangan ${responseData.nama ?? "PMI"} berhasil disimpan');
        Get.back(result: responseData);
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> saveUdara() async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response = await BaseClient()
          .postMultipart("/api/imigran/kepulangan/${imigran?.id}", {
        'id_kepulangan': kepulangan?.id,
        "id_bast_udara": bastUdara?.id,
        'foto_boarding_pass': fotoBoardingPass ?? "",
      });
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        final responseData = Imigran.fromJson(r['data']);
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            'Kepulangan ${responseData.nama ?? "PMI"} berhasil disimpan');
        Get.back(result: responseData);
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> saveRujukRsPolri() async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response = await BaseClient()
          .postMultipart("/api/imigran/kepulangan/${imigran?.id}", {
        'id_kepulangan': kepulangan?.id,
        'id_pihak_kedua': pihakKedua?.id,
        'tanggal_serah_terima':
            DateFormat('yyyy-MM-dd').format(tanggalSerahTerima!).toString(),
        "foto_pihak_kedua": fotoPihakKedua ?? "",
        'foto_serah_terima': fotoSerahTerima ?? "",
      });
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        final responseData = Imigran.fromJson(r['data']);
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            'Kepulangan ${responseData.nama ?? "PMI"} berhasil disimpan');
        Get.back(result: responseData);
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> savePulangMandiri() async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response = await BaseClient()
          .postMultipart("/api/imigran/kepulangan/${imigran?.id}", {
        'id_kepulangan': kepulangan?.id,
        'tanggal_serah_terima':
            DateFormat('yyyy-MM-dd').format(tanggalSerahTerima!).toString(),
        "foto_serah_terima": fotoSerahTerima ?? "",
      });
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        final responseData = Imigran.fromJson(r['data']);
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            'Kepulangan ${responseData.nama ?? "PMI"} berhasil disimpan');
        Get.back(result: responseData);
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> saveJemputKeluarga() async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response = await BaseClient()
          .postMultipart("/api/imigran/kepulangan/${imigran?.id}", {
        'id_kepulangan': kepulangan?.id,
        'nama_penjemput': namaPenjemputController.text,
        'hubungan_dengan_pmi': hubunganDenganPmiController.text,
        'no_telp_penjemput': noTelpPenjemputController.text,
        'tanggal_serah_terima':
            DateFormat('yyyy-MM-dd').format(tanggalSerahTerima!).toString(),
        "foto_penjemput": fotoPenjemput ?? "",
        'foto_serah_terima': fotoSerahTerima ?? "",
      });
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        final responseData = Imigran.fromJson(r['data']);
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            'Kepulangan ${responseData.nama ?? "PMI"} berhasil disimpan');
        Get.back(result: responseData);
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> saveJemputPihakLain() async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response = await BaseClient()
          .postMultipart("/api/imigran/kepulangan/${imigran?.id}", {
        'id_kepulangan': kepulangan?.id,
        "id_bast_pihak_lain": bastPihakLain?.id,
      });
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        final responseData = Imigran.fromJson(r['data']);
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            'Kepulangan ${responseData.nama ?? "PMI"} berhasil disimpan');
        Get.back(result: responseData);
      });
    } finally {
      EasyLoading.dismiss();
    }
  }
}
