import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/group.dart';
import 'package:kepulangan/app/data/models/user.dart';
import 'package:kepulangan/app/services/base_client.dart';

class CreatePenggunaController extends GetxController {
  final formState = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final noIdentitasController = TextEditingController();
  final jabatanController = TextEditingController();
  final groupController = TextEditingController();
  final teleponController = TextEditingController();
  final emailController = TextEditingController();
  final roleController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  int? idGroup;

  List<Group>? listGroup;
  List listRole = [
    'Petugas',
    'Admin',
  ];

  bool? isLoadingReferensi;
  bool isHidePassword = true;
  bool isHidePasswordConfirmation = true;

  @override
  void onClose() {
    namaController.dispose();
    noIdentitasController.dispose();
    jabatanController.dispose();
    groupController.dispose();
    teleponController.dispose();
    emailController.dispose();
    roleController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.onClose();
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

  Future<void> save() async {
    if (formState.currentState!.validate()) {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      try {
        final response = await BaseClient().post("/api/user/store", {
          'nama': namaController.text,
          'no_identitas': noIdentitasController.text,
          'jabatan': jabatanController.text,
          'id_group': idGroup,
          'telepon': teleponController.text,
          'email': emailController.text,
          'role': roleController.text,
          'password': passwordController.text,
          'password_confirmation': passwordConfirmationController.text,
        });
        response.fold((l) {
          EasyLoading.showError(l.toString());
        }, (r) async {
          final responseData = User.fromJson(r['data']);
          EasyLoading.showSuccess(
              '${responseData.nama ?? "Pengguna"} berhasil ditambahkan');
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
