import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/area.dart';
import 'package:kepulangan/app/data/models/cargo.dart';
import 'package:kepulangan/app/data/models/group.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/data/models/jabatan.dart';
import 'package:kepulangan/app/data/models/jenis_kelamin.dart';
import 'package:kepulangan/app/data/models/kab_kota.dart';
import 'package:kepulangan/app/data/models/kepulangan.dart';
import 'package:kepulangan/app/data/models/layanan.dart';
import 'package:kepulangan/app/data/models/masalah.dart';
import 'package:kepulangan/app/data/models/negara.dart';
import 'package:kepulangan/app/data/models/provinsi.dart';
import 'package:kepulangan/app/modules/main/controllers/main_controller.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/base_client.dart';

class CreateImigranController extends GetxController {
  Area? area = Get.arguments[0]['area'];
  Layanan? layanan = Get.arguments[1]['layanan'];
  bool? isPmi;
  bool? isJenazah;

  // Referensi
  List<JenisKelamin>? listAllJenisKelamin;
  List<JenisKelamin>? listJenisKelamin;
  List<Negara>? listAllNegara;
  List<Negara>? listNegara;
  List<Provinsi>? listAllProvinsi;
  List<Provinsi>? listProvinsi;
  List<KabKota>? listAllKabKota;
  List<KabKota>? listKabKota;
  List<Jabatan>? listAllJabatan;
  List<Jabatan>? listJabatan;
  List<Kepulangan>? listAllKepulangan;
  List<Kepulangan>? listKepulangan;
  List<Group>? listAllGroup;
  List<Group>? listGroup;
  List<Masalah>? listAllMasalah;
  List<Masalah>? listMasalah;
  List<Cargo>? listAllCargo;
  List<Cargo>? listCargo;
  bool? isLoadingReferensi;

  // Imigran
  final formState = GlobalKey<FormState>();
  final brafaksController = TextEditingController();
  final pasporController = TextEditingController();
  final namaController = TextEditingController();
  final jenisKelaminController = TextEditingController();
  final negaraController = TextEditingController();
  final alamatController = TextEditingController();
  final provinsiController = TextEditingController();
  final kabKotaController = TextEditingController();
  final noTelpController = TextEditingController();
  final jabatanController = TextEditingController();
  final tanggalKedatanganController = TextEditingController();
  final kepulanganController = TextEditingController();
  // PMI
  final groupController = TextEditingController();
  final masalahController = TextEditingController();
  // Jenazah
  final cargoController = TextEditingController();

  // Imigran
  int? idJenisKelamin;
  int? idNegara;
  int? idSubKawasan;
  int? idKawasan;
  int? idProvinsi;
  int? idKabKota;
  int? idJabatan;
  DateTime? tanggalKedatangan;
  int? idKepulangan;
  // PMI
  int? idGroup;
  int? idMasalah;
  File? fotoPmi;
  // Jenazah
  int? idCargo;
  File? fotoJenazah;
  File? fotoBrafaks;
  // PMI & jenazah
  File? fotoPaspor;

  @override
  void onInit() {
    isPmi =
        layanan!.group!.isNotEmpty && layanan?.masalah != null ? true : false;
    isJenazah = layanan!.cargo!.isNotEmpty ? true : false;
    super.onInit();
  }

  @override
  void onReady() {
    if (isPmi == true) {
      idGroup = AuthService.to.auth.value.group!.id;
      groupController.text = AuthService.to.auth.value.group!.nama!;
    }
    super.onReady();
  }

  @override
  void onClose() {
    brafaksController.dispose();
    pasporController.dispose();
    namaController.dispose();
    jenisKelaminController.dispose();
    negaraController.dispose();
    alamatController.dispose();
    provinsiController.dispose();
    kabKotaController.dispose();
    noTelpController.dispose();
    jabatanController.dispose();
    tanggalKedatanganController.dispose();
    kepulanganController.dispose();
    groupController.dispose();
    masalahController.dispose();
    cargoController.dispose();
    super.onClose();
  }

  String? validator(String value) {
    if (value.isEmpty) {
      return "Bidang ini wajib diisi";
    }
    return null;
  }

  Future<void> getJenisKelamin() async {
    try {
      isLoadingReferensi = true;
      final response = await BaseClient().get("/api/referensi/jenis-kelamin");
      response.fold((l) {
        listAllJenisKelamin = [];
        listJenisKelamin = [];
      }, (r) {
        List data = r['data'];
        listAllJenisKelamin =
            data.map((e) => JenisKelamin.fromJson(e)).toList();
        listJenisKelamin = data.map((e) => JenisKelamin.fromJson(e)).toList();
      });
    } finally {
      isLoadingReferensi = false;
      update();
    }
  }

  Future<void> getNegara() async {
    try {
      isLoadingReferensi = true;
      final response = await BaseClient().get("/api/referensi/negara");
      response.fold((l) {
        listAllNegara = [];
        listNegara = [];
      }, (r) {
        List data = r['data'];
        listAllNegara = data.map((e) => Negara.fromJson(e)).toList();
        listNegara = data.map((e) => Negara.fromJson(e)).toList();
      });
    } finally {
      isLoadingReferensi = false;
      update();
    }
  }

  Future<void> getProvinsi() async {
    try {
      isLoadingReferensi = true;
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
      isLoadingReferensi = false;
      update();
    }
  }

  Future<void> getKabKota() async {
    try {
      isLoadingReferensi = true;
      final response = await BaseClient()
          .get("/api/referensi/kab-kota?id_provinsi=${idProvinsi ?? ""}");
      response.fold((l) {
        listAllKabKota = [];
        listKabKota = [];
      }, (r) {
        List data = r['data'];
        listAllKabKota = data.map((e) => KabKota.fromJson(e)).toList();
        listKabKota = data.map((e) => KabKota.fromJson(e)).toList();
      });
    } finally {
      isLoadingReferensi = false;
      update();
    }
  }

  Future<void> getJabatan() async {
    try {
      isLoadingReferensi = true;
      final response = await BaseClient().get("/api/referensi/jabatan");
      response.fold((l) {
        listAllJabatan = [];
        listJabatan = [];
      }, (r) {
        List data = r['data'];
        listAllJabatan = data.map((e) => Jabatan.fromJson(e)).toList();
        listJabatan = data.map((e) => Jabatan.fromJson(e)).toList();
      });
    } finally {
      isLoadingReferensi = false;
      update();
    }
  }

  void getKepulangan() async {
    try {
      isLoadingReferensi = true;
      listAllKepulangan = layanan?.kepulangan?.toList();
      listKepulangan = layanan?.kepulangan?.toList();
    } finally {
      isLoadingReferensi = false;
      update();
    }
  }

  void getGroup() async {
    try {
      isLoadingReferensi = true;
      listAllGroup = layanan?.group?.toList();
      listGroup = layanan?.group?.toList();
    } finally {
      isLoadingReferensi = false;
      update();
    }
  }

  void getMasalah() async {
    try {
      isLoadingReferensi = true;
      listAllMasalah = layanan?.masalah?.toList();
      listMasalah = layanan?.masalah?.toList();
    } finally {
      isLoadingReferensi = false;
      update();
    }
  }

  void getCargo() async {
    try {
      isLoadingReferensi = true;
      listAllCargo = layanan?.cargo?.toList();
      listCargo = layanan?.cargo?.toList();
    } finally {
      isLoadingReferensi = false;
      update();
    }
  }

  void getFotoPmi(ImageSource imageSource) async {
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
      fotoPmi = File(compressImage!.path);
    } catch (e) {
      EasyLoading.showError(e.toString());
      fotoPmi = null;
    } finally {
      update();
    }
  }

  void getFotoPaspor(ImageSource imageSource) async {
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
      fotoPaspor = File(compressImage!.path);
    } catch (e) {
      EasyLoading.showError(e.toString());
      fotoPaspor = null;
    } finally {
      update();
    }
  }

  void getFotoJenazah(ImageSource imageSource) async {
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
      fotoJenazah = File(compressImage!.path);
    } catch (e) {
      EasyLoading.showError(e.toString());
      fotoJenazah = null;
    } finally {
      update();
    }
  }

  void getFotoBrafaks(ImageSource imageSource) async {
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
      fotoBrafaks = File(compressImage!.path);
    } catch (e) {
      EasyLoading.showError(e.toString());
      fotoBrafaks = null;
    } finally {
      update();
    }
  }

  void save() async {
    if (formState.currentState!.validate()) {
      if (isPmi == true) {
        if (fotoPmi == null) {
          EasyLoading.showError("Foto PMI wajib diisi");
          return;
        }
        if (fotoPaspor == null) {
          EasyLoading.showError("Foto Paspor wajib diisi");
          return;
        }
        await savePmi();
      }
      if (isJenazah == true) {
        if (fotoJenazah == null) {
          EasyLoading.showError("Foto Jenazah wajib diisi");
          return;
        }
        if (fotoPaspor == null) {
          EasyLoading.showError("Foto Paspor wajib diisi");
          return;
        }
        if (fotoBrafaks == null) {
          EasyLoading.showError("Foto Brafaks wajib diisi");
          return;
        }
        await saveJenazah();
      }
    } else {
      EasyLoading.showError("Gagal.\nPeriksa kembali inputan Anda");
    }
  }

  Future<void> savePmi() async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response = await BaseClient().postMultipart("/api/imigran/store", {
        'brafaks': brafaksController.text,
        'paspor': pasporController.text,
        'nama': namaController.text,
        'id_jenis_kelamin': idJenisKelamin,
        'id_negara': idNegara,
        'id_sub_kawasan': idSubKawasan,
        'id_kawasan': idKawasan,
        'alamat': alamatController.text,
        'id_kab_kota': idKabKota,
        'id_provinsi': idProvinsi,
        'no_telp': noTelpController.text,
        'id_jabatan': idJabatan,
        'tanggal_kedatangan':
            DateFormat('yyyy-MM-dd').format(tanggalKedatangan!),
        'id_area': area?.id,
        'id_layanan': layanan?.id,
        'id_group': idGroup,
        'id_masalah': idMasalah,
        'foto_pmi': fotoPmi ?? "",
        'foto_paspor': fotoPaspor ?? "",
      });
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        final responseData = Imigran.fromJson(r['data']);
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            "${responseData.nama ?? "PMI"} berhasil ditambahkan");
        Get.offNamed(Routes.detailImigran, arguments: responseData);
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> saveJenazah() async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final response = await BaseClient().postMultipart("/api/imigran/store", {
        'brafaks': brafaksController.text,
        'paspor': pasporController.text,
        'nama': namaController.text,
        'id_jenis_kelamin': idJenisKelamin,
        'id_negara': idNegara,
        'id_sub_kawasan': idSubKawasan,
        'id_kawasan': idKawasan,
        'alamat': alamatController.text,
        'id_kab_kota': idKabKota,
        'id_provinsi': idProvinsi,
        'no_telp': noTelpController.text,
        'id_jabatan': idJabatan,
        'tanggal_kedatangan':
            DateFormat('yyyy-MM-dd').format(tanggalKedatangan!),
        'id_area': area?.id,
        'id_layanan': layanan?.id,
        'id_kepulangan': idKepulangan,
        'id_cargo': idCargo,
        'foto_jenazah': fotoJenazah ?? "",
        'foto_paspor': fotoPaspor ?? "",
        'foto_brafaks': fotoBrafaks ?? "",
      });
      response.fold((l) {
        EasyLoading.showError(l.toString());
      }, (r) async {
        final responseData = Imigran.fromJson(r['data']);
        MainController.to.generateRefreshKey(10);
        EasyLoading.showSuccess(
            "${responseData.nama ?? "Jenazah"} berhasil ditambahkan");
        Get.offNamed(Routes.detailImigran, arguments: responseData);
      });
    } finally {
      EasyLoading.dismiss();
    }
  }
}
