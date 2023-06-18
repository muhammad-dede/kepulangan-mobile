import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/widgets/date_picker_widget.dart';
import 'package:kepulangan/app/widgets/image_picker_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/kepulangan_controller.dart';

class FormPulangMandiriPage extends GetView<KepulanganController> {
  const FormPulangMandiriPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Header(),
        InputTanggalSerahTerima(),
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
            var status = await Permission.camera.status;
            if (status.isDenied) {
              if (await Permission.camera.request().isGranted) {
                controller.getFotoSerahTerima(ImageSource.camera);
              } else {
                openAppSettings();
              }
            } else {
              controller.getFotoSerahTerima(ImageSource.camera);
            }
            Get.back();
          },
          onTapGalery: () async {
            var status = await Permission.storage.status;
            if (status.isDenied) {
              if (await Permission.storage.request().isGranted) {
                controller.getFotoSerahTerima(ImageSource.gallery);
              } else {
                openAppSettings();
              }
            } else {
              controller.getFotoSerahTerima(ImageSource.gallery);
            }
            Get.back();
          },
        );
      },
    );
  }
}
