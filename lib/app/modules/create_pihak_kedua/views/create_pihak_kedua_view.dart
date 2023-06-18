import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';

import '../controllers/create_pihak_kedua_controller.dart';

class CreatePihakKeduaView extends GetView<CreatePihakKeduaController> {
  const CreatePihakKeduaView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pihak Kedua'),
        actions: [
          TextButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              await controller.save();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
      body: Form(
        key: controller.formState,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: const [
            Nama(),
            NoIdentitas(),
            Jabatan(),
            Instansi(),
            Alamat(),
            NoTelp(),
          ],
        ),
      ),
    );
  }
}

class Nama extends GetView<CreatePihakKeduaController> {
  const Nama({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Nama",
        readOnly: false,
        controller: controller.namaController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class NoIdentitas extends GetView<CreatePihakKeduaController> {
  const NoIdentitas({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "No. Identitas",
        readOnly: false,
        controller: controller.noIdentitasController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class Jabatan extends GetView<CreatePihakKeduaController> {
  const Jabatan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Jabatan",
        readOnly: false,
        controller: controller.jabatanController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class Instansi extends GetView<CreatePihakKeduaController> {
  const Instansi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Instansi",
        readOnly: false,
        controller: controller.instansiController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class Alamat extends GetView<CreatePihakKeduaController> {
  const Alamat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Alamat",
        readOnly: false,
        controller: controller.alamatController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class NoTelp extends GetView<CreatePihakKeduaController> {
  const NoTelp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "No. Telepon",
        readOnly: false,
        controller: controller.noTelpController,
        obscureText: false,
        keyboardType: TextInputType.phone,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}
