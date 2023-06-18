import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/group.dart';
import 'package:kepulangan/app/data/models/user.dart';
import 'package:kepulangan/app/services/base_client.dart';

class EditPenggunaController extends GetxController {
  User? pengguna = Get.arguments;

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
    roleController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.onClose();
  }

  void getEditData() {
    try {
      namaController.text = pengguna?.nama ?? "";
      noIdentitasController.text = pengguna?.noIdentitas ?? "";
      jabatanController.text = pengguna?.jabatan ?? "";
      groupController.text = pengguna?.group?.nama ?? "";
      teleponController.text = pengguna?.telepon ?? "";
      emailController.text = pengguna?.email ?? "";
      roleController.text = pengguna?.role ?? "";
      idGroup = pengguna?.group?.id;
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
      try {
        EasyLoading.show(
            status: 'loading...', maskType: EasyLoadingMaskType.black);
        final response =
            await BaseClient().post("/api/user/update/${pengguna?.id}", {
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
              '${responseData.nama ?? "Pengguna"} berhasil disimpan');
          Get.back(result: responseData);
        });
      } finally {
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.showError('Gagal.\nPeriksa kembali inputan Anda');
    }
  }
}
