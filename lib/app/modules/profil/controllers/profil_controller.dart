import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kepulangan/app/data/models/group.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/base_client.dart';

class ProfilController extends GetxController {
  final formState = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final noIdentitasController = TextEditingController();
  final jabatanController = TextEditingController();
  final groupController = TextEditingController();
  final teleponController = TextEditingController();
  final emailController = TextEditingController();
  File? avatar;
  int? idGroup;

  List<Group>? listGroup;
  bool? isLoadingReferensi;

  @override
  void onInit() {
    getEditData();
    super.onInit();
  }

  @override
  void onClose() {
    namaController.dispose();
    noIdentitasController.dispose();
    jabatanController.dispose();
    groupController.dispose();
    teleponController.dispose();
    emailController.dispose();
    super.onClose();
  }

  void getEditData() {
    namaController.text = AuthService.to.auth.value.nama ?? "";
    noIdentitasController.text = AuthService.to.auth.value.noIdentitas ?? "";
    jabatanController.text = AuthService.to.auth.value.jabatan ?? "";
    groupController.text = AuthService.to.auth.value.group?.nama ?? "";
    teleponController.text = AuthService.to.auth.value.telepon ?? "";
    emailController.text = AuthService.to.auth.value.email ?? "";
    idGroup = AuthService.to.auth.value.group?.id;
  }

  String? validator(String value) {
    if (value.isEmpty) {
      return "Bidang ini wajib diisi";
    }
    return null;
  }

  Future<void> getGroup() async {
    try {
      isLoadingReferensi = true;
      final response = await BaseClient().get("/api/referensi/group");
      response.fold((l) {
        listGroup = [];
      }, (r) {
        List data = r['data'];
        listGroup = data.map((e) => Group.fromJson(e)).toList();
      });
    } finally {
      isLoadingReferensi = false;
      update();
    }
  }

  void getAvatar(ImageSource imageSource) async {
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
      avatar = File(compressImage!.path);
    } catch (e) {
      EasyLoading.showError(e.toString());
      avatar = null;
    } finally {
      update();
    }
  }

  Future<void> save() async {
    if (formState.currentState!.validate()) {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      try {
        final response =
            await BaseClient().postMultipart("/api/auth/update/profil", {
          'nama': namaController.text,
          'no_identitas': noIdentitasController.text,
          'jabatan': jabatanController.text,
          'id_group': idGroup,
          'telepon': teleponController.text,
          'email': emailController.text,
          "avatar": avatar ?? "",
        });
        response.fold((l) {
          EasyLoading.showError(l.toString());
        }, (r) async {
          EasyLoading.showSuccess('Berhasil disimpan');
          await AuthService.to.me();
          Get.back();
        });
      } finally {
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.showError("Gagal.\nPeriksa kembali inputan Anda");
    }
  }
}
