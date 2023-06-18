import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/services/permission_service.dart';
import 'package:kepulangan/app/widgets/date_picker_widget.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';
import 'package:kepulangan/app/widgets/image_picker_widget.dart';

import '../controllers/kepulangan_controller.dart';

class FormJemputKeluargaPage extends GetView<KepulanganController> {
  const FormJemputKeluargaPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Header(),
        InputNamaPenjemput(),
        InputHubunganDenganPmi(),
        InputNoTelpPenjemput(),
        InputTanggalSerahTerima(),
        InputFotoPenjemput(),
        InputFotoSerahTerima(),
      ],
    );
  }
}

class Header extends GetView<KepulanganController> {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: Card(
        child: ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(controller.imigran?.nama ?? ""),
          subtitle: Text(controller.imigran?.paspor ?? ""),
          trailing: Text(controller.imigran?.area!.nama ?? ""),
        ),
      ),
    );
  }
}

class InputNamaPenjemput extends GetView<KepulanganController> {
  const InputNamaPenjemput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Nama Penjemput",
        readOnly: false,
        controller: controller.namaPenjemputController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class InputHubunganDenganPmi extends GetView<KepulanganController> {
  const InputHubunganDenganPmi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Hubungan dengan PMI",
        readOnly: false,
        controller: controller.hubunganDenganPmiController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class InputNoTelpPenjemput extends GetView<KepulanganController> {
  const InputNoTelpPenjemput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "No. Telepon Penjemput",
        readOnly: false,
        controller: controller.noTelpPenjemputController,
        obscureText: false,
        keyboardType: TextInputType.phone,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class InputTanggalSerahTerima extends GetView<KepulanganController> {
  const InputTanggalSerahTerima({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DatePickerWidget(
        labelText: "Tanggal Serah Terima",
        controller: controller.tanggalSerahTerimaController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () async {
          DateTime? datePicker = await showDatePicker(
            context: Get.context!,
            initialDate: controller.tanggalSerahTerima ?? DateTime.now(),
            firstDate: DateTime(1945),
            lastDate: DateTime(DateTime.now().year + 1),
          );
          if (datePicker != null) {
            controller.tanggalSerahTerima = datePicker;
            controller.tanggalSerahTerimaController.text =
                DateFormat('dd-MM-yyyy').format(datePicker).toString();
          }
        },
      ),
    );
  }
}

class InputFotoPenjemput extends GetView<KepulanganController> {
  const InputFotoPenjemput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KepulanganController>(
      builder: (controller) {
        return ImagePickerWidget(
          title: "Foto Penjemput",
          imageFile: controller.fotoPenjemput,
          imageNetwork: controller.fotoPenjemputOld,
          onDelete: () {
            controller.fotoPenjemput = null;
            controller.update();
          },
          onTapCamera: () async {
            await PermissionService.to.cameraRequest().then((value) {
              if (value == true) {
                controller.getFotoPenjemput(ImageSource.camera);
              }
            });
            Get.back();
          },
          onTapGalery: () async {
            await PermissionService.to.storageRequest().then((value) {
              if (value == true) {
                controller.getFotoPenjemput(ImageSource.gallery);
              }
            });
            Get.back();
          },
        );
      },
    );
  }
}

class InputFotoSerahTerima extends GetView<KepulanganController> {
  const InputFotoSerahTerima({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KepulanganController>(
      builder: (controller) {
        return ImagePickerWidget(
          title: "Foto Serah Terima",
          imageFile: controller.fotoSerahTerima,
          imageNetwork: controller.fotoSerahTerimaOld,
          onDelete: () {
            controller.fotoSerahTerima = null;
            controller.update();
          },
          onTapCamera: () async {
            await PermissionService.to.cameraRequest().then((value) {
              if (value == true) {
                controller.getFotoSerahTerima(ImageSource.camera);
              }
            });
            Get.back();
          },
          onTapGalery: () async {
            await PermissionService.to.storageRequest().then((value) {
              if (value == true) {
                controller.getFotoSerahTerima(ImageSource.gallery);
              }
            });
            Get.back();
          },
        );
      },
    );
  }
}
