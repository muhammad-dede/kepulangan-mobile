import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kepulangan/app/widgets/switch_widget.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';

import '../controllers/edit_alamat_controller.dart';

class EditAlamatView extends GetView<EditAlamatController> {
  const EditAlamatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Alamat'),
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
            InputJudul(),
            InputLokasi(),
            InputUtama(),
          ],
        ),
      ),
    );
  }
}

class InputJudul extends GetView<EditAlamatController> {
  const InputJudul({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Judul",
        readOnly: false,
        controller: controller.judulController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class InputLokasi extends GetView<EditAlamatController> {
  const InputLokasi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Lokasi",
        readOnly: false,
        controller: controller.lokasiController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class InputUtama extends GetView<EditAlamatController> {
  const InputUtama({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditAlamatController>(
      builder: (controller) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: SwitchWidget(
            labelText: "Atur sebagai alamat utama",
            value: controller.utama,
            onChanged: (bool value) {
              controller.utama = value;
              controller.update();
            },
          ),
        );
      },
    );
  }
}
