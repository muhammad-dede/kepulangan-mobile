import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/widgets/date_picker_widget.dart';
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
            TanggalPks(),
            NoDipa(),
            TanggalDipa(),
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
        labelText: "No PKS",
        readOnly: false,
        controller: controller.noPksController,
        obscureText: false,
        keyboardType: TextInputType.text,
      ),
    );
  }
}

class TanggalPks extends GetView<CreatePenyediaJasaController> {
  const TanggalPks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DatePickerWidget(
        labelText: "Tanggal PKS",
        controller: controller.tanggalPksController,
        onTap: () async {
          DateTime? datePicker = await showDatePicker(
            context: Get.context!,
            initialDate: controller.tanggalPks ?? DateTime.now(),
            firstDate: DateTime(1945),
            lastDate: DateTime(DateTime.now().year + 1),
          );
          if (datePicker != null) {
            controller.tanggalPks = datePicker;
            controller.tanggalPksController.text =
                DateFormat('dd-MM-yyyy').format(datePicker).toString();
          }
        },
      ),
    );
  }
}

class NoDipa extends GetView<CreatePenyediaJasaController> {
  const NoDipa({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "No DIPA",
        readOnly: false,
        controller: controller.noDipaController,
        obscureText: false,
        keyboardType: TextInputType.text,
      ),
    );
  }
}

class TanggalDipa extends GetView<CreatePenyediaJasaController> {
  const TanggalDipa({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DatePickerWidget(
        labelText: "Tanggal DIPA",
        controller: controller.tanggalDipaController,
        onTap: () async {
          DateTime? datePicker = await showDatePicker(
            context: Get.context!,
            initialDate: controller.tanggalDipa ?? DateTime.now(),
            firstDate: DateTime(1945),
            lastDate: DateTime(DateTime.now().year + 1),
          );
          if (datePicker != null) {
            controller.tanggalDipa = datePicker;
            controller.tanggalDipaController.text =
                DateFormat('dd-MM-yyyy').format(datePicker).toString();
          }
        },
      ),
    );
  }
}
