import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/widgets/date_picker_widget.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';

import '../controllers/edit_penyedia_jasa_controller.dart';

class EditPenyediaJasaView extends GetView<EditPenyediaJasaController> {
  const EditPenyediaJasaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Penyedia Jasa'),
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

class NamaPerusahaan extends GetView<EditPenyediaJasaController> {
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

class Alamat extends GetView<EditPenyediaJasaController> {
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

class Email extends GetView<EditPenyediaJasaController> {
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

class NoTelp extends GetView<EditPenyediaJasaController> {
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

class Up extends GetView<EditPenyediaJasaController> {
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

class NoPks extends GetView<EditPenyediaJasaController> {
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

class TanggalPks extends GetView<EditPenyediaJasaController> {
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
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

class NoDipa extends GetView<EditPenyediaJasaController> {
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

class TanggalDipa extends GetView<EditPenyediaJasaController> {
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
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
