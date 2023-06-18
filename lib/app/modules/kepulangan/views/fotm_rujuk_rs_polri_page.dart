import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/pihak_kedua.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/permission_service.dart';
import 'package:kepulangan/app/widgets/date_picker_widget.dart';
import 'package:kepulangan/app/widgets/list_detail_widget.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';
import 'package:kepulangan/app/widgets/image_picker_widget.dart';

import '../controllers/kepulangan_controller.dart';

class FormRujukRsPolriPage extends GetView<KepulanganController> {
  const FormRujukRsPolriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Header(),
        InputPihakKedua(),
        InputTanggalSerahTerima(),
        InputFotoPihakKedua(),
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

class InputPihakKedua extends GetView<KepulanganController> {
  const InputPihakKedua({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KepulanganController>(
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text("Data Pihak Kedua"),
                subtitle: const Text("Pilih Data Pihak Kedua"),
                trailing: GestureDetector(
                  onTap: () async {
                    dynamic result = await Get.toNamed(Routes.createPihakKedua);
                    if (result != null) {
                      controller.pihakKedua = result as PihakKedua;
                    } else {
                      controller.pihakKedua = controller.pihakKedua;
                    }
                    controller.update();
                  },
                  child: const CircleAvatar(
                      child: Icon(Icons.person_add_alt_outlined)),
                ),
                onTap: () {
                  controller.getPihakKedua();
                  showPihakKedua();
                },
              ),
              if (controller.pihakKedua != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      const Divider(),
                      ListDetailWidget(
                        title: "Nama Pihak Kedua",
                        subtitle: controller.pihakKedua?.nama ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "No. Identitas Pihak Kedua",
                        subtitle: controller.pihakKedua?.noIdentitas ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Jabatan Pihak Kedua",
                        subtitle: controller.pihakKedua?.jabatan ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Instansi Pihak Kedua",
                        subtitle: controller.pihakKedua?.instansi ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Alamat Pihak Kedua",
                        subtitle: controller.pihakKedua?.alamat ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "No. Telepon Pihak Kedua",
                        subtitle: controller.pihakKedua?.noTelp ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Tanggal Serah Terima",
                        subtitle: controller.pihakKedua?.noTelp ?? "-",
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
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

class InputFotoPihakKedua extends GetView<KepulanganController> {
  const InputFotoPihakKedua({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KepulanganController>(
      builder: (controller) {
        return ImagePickerWidget(
          title: "Foto Pihak Kedua",
          imageFile: controller.fotoPihakKedua,
          imageNetwork: controller.fotoPihakKeduaOld,
          onDelete: () {
            controller.fotoPihakKedua = null;
            controller.update();
          },
          onTapCamera: () async {
            await PermissionService.to.cameraRequest().then((value) {
              if (value == true) {
                controller.getFotoPihakKedua(ImageSource.camera);
              }
            });
            Get.back();
          },
          onTapGalery: () async {
            await PermissionService.to.storageRequest().then((value) {
              if (value == true) {
                controller.getFotoPihakKedua(ImageSource.gallery);
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

void showPihakKedua() {
  Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: false,
    enableDrag: false,
    isDismissible: false,
    GetBuilder<KepulanganController>(
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("Pilih"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Selesai'),
              )
            ],
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                child: TextFormFieldWidget(
                  readOnly: false,
                  hintText: "Cari",
                  prefixIcon: const Icon(Icons.search),
                  obscureText: false,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      controller.listPihakKedua = controller.listAllPihakKedua!
                          .where((item) =>
                              item.nama!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              item.noIdentitas!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                          .toList();
                    } else {
                      controller.listPihakKedua = controller.listAllPihakKedua;
                    }
                    controller.update();
                  },
                ),
              ),
              Expanded(
                child: controller.isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : controller.listPihakKedua!.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.listPihakKedua?.length,
                            itemBuilder: (context, index) {
                              final item = controller.listPihakKedua?[index];
                              return ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(item?.nama ?? ""),
                                subtitle: Text(item?.noIdentitas ?? ""),
                                trailing: controller.pihakKedua?.id == item?.id
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )
                                    : const Icon(Icons.check_circle_outline),
                                onTap: () {
                                  if (controller.pihakKedua != null) {
                                    if (controller.pihakKedua == item) {
                                      controller.pihakKedua = null;
                                    } else {
                                      controller.pihakKedua = item;
                                    }
                                  } else {
                                    controller.pihakKedua = item;
                                  }
                                  controller.update();
                                },
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text('Data tidak ditemukan'),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.getPihakKedua();
                                    controller.update();
                                  },
                                  child: const Icon(Icons.refresh, size: 40),
                                ),
                              ],
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
