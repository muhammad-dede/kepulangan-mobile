import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';

import '../controllers/create_penyedia_jasa_controller.dart';

class CreatePenyediaJasaView extends GetView<CreatePenyediaJasaController> {
  const CreatePenyediaJasaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Penyedia Jasa'),
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
            NamaPerusahaan(),
            Alamat(),
            Email(),
            NoTelp(),
            Up(),
            NoPks(),
            TahunPks(),
            NoDiva(),
            TahunDiva(),
          ],
        ),
      ),
    );
  }
}

class NamaPerusahaan extends GetView<CreatePenyediaJasaController> {
  const NamaPerusahaan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Nama Perusahaan",
        readOnly: false,
        controller: controller.namaPerusahaanController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class Alamat extends GetView<CreatePenyediaJasaController> {
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
      ),
    );
  }
}

class Email extends GetView<CreatePenyediaJasaController> {
  const Email({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Email",
        readOnly: false,
        controller: controller.emailController,
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}

class NoTelp extends GetView<CreatePenyediaJasaController> {
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
      ),
    );
  }
}

class Up extends GetView<CreatePenyediaJasaController> {
  const Up({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Up",
        readOnly: false,
        controller: controller.upController,
        obscureText: false,
        keyboardType: TextInputType.text,
      ),
    );
  }
}

class NoPks extends GetView<CreatePenyediaJasaController> {
  const NoPks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "No Pks",
        readOnly: false,
        controller: controller.noPksController,
        obscureText: false,
        keyboardType: TextInputType.text,
      ),
    );
  }
}

class TahunPks extends GetView<CreatePenyediaJasaController> {
  const TahunPks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Tahun Pks",
        readOnly: false,
        controller: controller.tahunPksController,
        obscureText: false,
        keyboardType: TextInputType.text,
      ),
    );
  }
}

class NoDiva extends GetView<CreatePenyediaJasaController> {
  const NoDiva({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "No Diva",
        readOnly: false,
        controller: controller.noDivaController,
        obscureText: false,
        keyboardType: TextInputType.text,
      ),
    );
  }
}

class TahunDiva extends GetView<CreatePenyediaJasaController> {
  const TahunDiva({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Tahun Diva",
        readOnly: false,
        controller: controller.tahunDivaController,
        obscureText: false,
        keyboardType: TextInputType.text,
      ),
    );
  }
}
