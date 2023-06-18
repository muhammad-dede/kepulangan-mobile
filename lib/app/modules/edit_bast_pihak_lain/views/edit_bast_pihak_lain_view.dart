import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/data/models/jemput_pihak_lain.dart';
import 'package:kepulangan/app/data/models/pihak_kedua.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/widgets/date_picker_widget.dart';
import 'package:kepulangan/app/widgets/image_picker_widget.dart';
import 'package:kepulangan/app/widgets/list_detail_widget.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/edit_bast_pihak_lain_controller.dart';

class EditBastPihakLainView extends GetView<EditBastPihakLainController> {
  const EditBastPihakLainView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pihak Lain"),
        actions: [
          TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              controller.save();
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
            InputPihakKedua(),
            InputTanggalSerahTerima(),
            InputImigran(),
            InputFotoPihakKedua(),
            InputFotoSerahTerima(),
          ],
        ),
      ),
    );
  }
}

class InputPihakKedua extends GetView<EditBastPihakLainController> {
  const InputPihakKedua({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditBastPihakLainController>(
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
                subtitle: const Text("Pilih Pihak Kedua"),
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
                        title: "Nama",
                        subtitle: controller.pihakKedua?.nama ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "No. Identitas",
                        subtitle: controller.pihakKedua?.noIdentitas ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Jabatan",
                        subtitle: controller.pihakKedua?.jabatan ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Instansi",
                        subtitle: controller.pihakKedua?.instansi ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Alamat",
                        subtitle: controller.pihakKedua?.alamat ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "No. Telepon",
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

void showPihakKedua() {
  Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: false,
    enableDrag: false,
    isDismissible: false,
    GetBuilder<EditBastPihakLainController>(
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

class InputTanggalSerahTerima extends GetView<EditBastPihakLainController> {
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

class InputFotoPihakKedua extends GetView<EditBastPihakLainController> {
  const InputFotoPihakKedua({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditBastPihakLainController>(
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
            var status = await Permission.camera.status;
            if (status.isDenied) {
              if (await Permission.camera.request().isGranted) {
                controller.getFotoPihakKedua(ImageSource.camera);
              } else {
                openAppSettings();
              }
            } else {
              controller.getFotoPihakKedua(ImageSource.camera);
            }
            Get.back();
          },
          onTapGalery: () async {
            var status = await Permission.storage.status;
            if (status.isDenied) {
              if (await Permission.storage.request().isGranted) {
                controller.getFotoPihakKedua(ImageSource.gallery);
              } else {
                openAppSettings();
              }
            } else {
              controller.getFotoPihakKedua(ImageSource.gallery);
            }
            Get.back();
          },
        );
      },
    );
  }
}

class InputFotoSerahTerima extends GetView<EditBastPihakLainController> {
  const InputFotoSerahTerima({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditBastPihakLainController>(
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

class InputImigran extends GetView<EditBastPihakLainController> {
  const InputImigran({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditBastPihakLainController>(
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
                title: const Text("Data PMI"),
                subtitle: const Text("Pilih PMI"),
                onTap: () {
                  controller.getImigran();
                  showImigran();
                },
              ),
              if (controller.listJemputPihakLain!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    children: controller.listJemputPihakLain!.map(
                      (item) {
                        return GestureDetector(
                          onTap: () {
                            showDetailImigran(item.imigran);
                          },
                          child: Chip(
                            avatar: const Icon(Icons.account_circle),
                            label: Text(item.imigran?.nama ?? ""),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

void showImigran() {
  Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: false,
    enableDrag: false,
    isDismissible: false,
    GetBuilder<EditBastPihakLainController>(
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
                      controller.listImigran = controller.listAllImigran!
                          .where((item) => item.nama!
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    } else {
                      controller.listImigran = controller.listAllImigran;
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
                    : controller.listImigran!.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.listImigran?.length,
                            itemBuilder: (context, index) {
                              final item = controller.listImigran?[index];
                              return ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(item?.nama ?? ""),
                                subtitle: Text(item?.paspor ?? ""),
                                trailing: controller.listJemputPihakLain!
                                        .where((element) =>
                                            element.imigran?.id == item?.id)
                                        .isNotEmpty
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )
                                    : const Icon(Icons.check_circle_outline),
                                onTap: () {
                                  if (controller.listJemputPihakLain!
                                      .where((element) =>
                                          element.imigran?.id == item!.id)
                                      .isNotEmpty) {
                                    controller.listJemputPihakLain!.removeWhere(
                                        (element) =>
                                            element.imigran?.id == item?.id);
                                  } else {
                                    controller.listJemputPihakLain!
                                        .add(JemputPihakLain(imigran: item));
                                  }
                                  controller.update();
                                },
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text('Data tidak ditemukan'),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.getImigran();
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

void showDetailImigran(Imigran? imigran) {
  Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: false,
    enableDrag: false,
    isDismissible: false,
    GetBuilder<EditBastPihakLainController>(
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("Detail PMI"),
          ),
          body: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              Card(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListDetailWidget(
                        title: "Brafaks",
                        subtitle: imigran?.brafaks ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Paspor",
                        subtitle: imigran?.paspor ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Nama",
                        subtitle: imigran?.nama ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Jenis Kelamin",
                        subtitle: imigran?.jenisKelamin?.nama ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Negara",
                        subtitle: imigran?.negara?.nama ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Sub Kawasan",
                        subtitle: imigran?.subKawasan?.nama ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Kawasan",
                        subtitle: imigran?.kawasan?.nama ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Alamat",
                        subtitle: imigran?.alamat ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Provinsi",
                        subtitle: imigran?.provinsi?.nama ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Kabupaten/Kota",
                        subtitle: imigran?.kabKota?.nama ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "No. Telepon",
                        subtitle: imigran?.noTelp ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Jabatan",
                        subtitle: imigran?.jabatan?.nama ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Tanggal Kedatangan",
                        subtitle: imigran?.tanggalKedatangan != null
                            ? DateFormat('dd MMMM yyyy', "id_ID")
                                .format(DateTime.parse(
                                    imigran!.tanggalKedatangan.toString()))
                                .toString()
                            : "-",
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
