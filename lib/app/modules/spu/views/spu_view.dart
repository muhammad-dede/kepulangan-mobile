import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/widgets/date_picker_widget.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/spu_controller.dart';

class SpuView extends GetView<SpuController> {
  const SpuView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Surat Perintah Udara"),
        actions: [
          TextButton(
            onPressed: () {
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
            Header(),
            InputNoSurat(),
            InputTanggalSurat(),
            InputProvinsi(),
            InputNoPesawat(),
            InputJamPesawat(),
            InputTanggalPesawat(),
            InputSpuTiket(),
          ],
        ),
      ),
    );
  }
}

class Header extends GetView<SpuController> {
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
            child: Icon(Icons.article_outlined),
          ),
          title: Text(controller.bastUdara?.purchaseOrder ?? ""),
          subtitle:
              Text(controller.bastUdara?.penyediaJasa?.namaPerusahaan ?? ""),
        ),
      ),
    );
  }
}

class InputNoSurat extends GetView<SpuController> {
  const InputNoSurat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "No Surat",
        readOnly: false,
        controller: controller.noSuratController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class InputTanggalSurat extends GetView<SpuController> {
  const InputTanggalSurat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DatePickerWidget(
        labelText: "Tanggal Surat",
        controller: controller.tanggalSuratController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () async {
          DateTime? datePicker = await showDatePicker(
            context: Get.context!,
            initialDate: controller.tanggalSurat ?? DateTime.now(),
            firstDate: DateTime(1945),
            lastDate: DateTime(DateTime.now().year + 1),
          );
          if (datePicker != null) {
            controller.tanggalSurat = datePicker;
            controller.tanggalSuratController.text =
                DateFormat('dd-MM-yyyy').format(datePicker).toString();
          }
        },
      ),
    );
  }
}

class InputProvinsi extends GetView<SpuController> {
  const InputProvinsi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Provinsi",
        readOnly: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        controller: controller.provinsiController,
        obscureText: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () {
          controller.getProvinsi();
          Get.bottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            GetBuilder<SpuController>(
              builder: (controller) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Pilih Provinsi',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: GestureDetector(
                        child: const Icon(Icons.close),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                    const Divider(height: 0),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: TextFormFieldWidget(
                        readOnly: false,
                        hintText: "Cari",
                        prefixIcon: const Icon(Icons.search),
                        obscureText: false,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            controller.listProvinsi = controller
                                .listAllProvinsi!
                                .where((item) => item.nama!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          } else {
                            controller.listProvinsi =
                                controller.listAllProvinsi;
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
                          : controller.listProvinsi != null
                              ? ListView.builder(
                                  itemCount: controller.listProvinsi!.length,
                                  itemBuilder: (context, index) {
                                    final item =
                                        controller.listProvinsi![index];
                                    return ListTile(
                                      title: Text(item.nama ?? ""),
                                      trailing: controller.idProvinsi == item.id
                                          ? const Icon(Icons.check)
                                          : null,
                                      onTap: () {
                                        controller.idProvinsi = item.id;
                                        controller.provinsiController.text =
                                            item.nama ?? "";
                                        controller.update();
                                        Get.back();
                                      },
                                    );
                                  },
                                )
                              : Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.getProvinsi();
                                      controller.update();
                                    },
                                    child: const Icon(Icons.refresh, size: 40),
                                  ),
                                ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class InputNoPesawat extends GetView<SpuController> {
  const InputNoPesawat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "No Pesawat",
        readOnly: false,
        controller: controller.noPesawatController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class InputJamPesawat extends GetView<SpuController> {
  const InputJamPesawat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DatePickerWidget(
        labelText: "Jam Pesawat",
        controller: controller.jamPesawatController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () async {
          TimeOfDay? timePicker = await showTimePicker(
            context: context,
            initialTime: controller.jamPesawatController.text != ""
                ? TimeOfDay(
                    hour: int.parse(
                        controller.jamPesawatController.text.split(":")[0]),
                    minute: int.parse(
                        controller.jamPesawatController.text.split(":")[1]))
                : TimeOfDay.now(),
          );
          if (timePicker != null) {
            controller.jamPesawatController.text =
                "${timePicker.hour}:${timePicker.minute}";
          }
        },
      ),
    );
  }
}

class InputTanggalPesawat extends GetView<SpuController> {
  const InputTanggalPesawat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DatePickerWidget(
        labelText: "Tanggal Pesawat",
        controller: controller.tanggalPesawatController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () async {
          DateTime? datePicker = await showDatePicker(
            context: Get.context!,
            initialDate: controller.tanggalPesawat ?? DateTime.now(),
            firstDate: DateTime(1945),
            lastDate: DateTime(DateTime.now().year + 1),
          );
          if (datePicker != null) {
            controller.tanggalPesawat = datePicker;
            controller.tanggalPesawatController.text =
                DateFormat('dd-MM-yyyy').format(datePicker).toString();
          }
        },
      ),
    );
  }
}

class InputSpuTiket extends GetView<SpuController> {
  const InputSpuTiket({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpuController>(
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
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text("Foto Tiket"),
                subtitle: const Text("Pilih Foto Tiket"),
                trailing: const CircleAvatar(child: Icon(Icons.add_a_photo)),
                onTap: () {
                  Get.bottomSheet(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    Wrap(
                      children: [
                        ListTile(
                          title: const Text(
                            "Foto Tiket",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: GestureDetector(
                            child: const Icon(Icons.close),
                            onTap: () {
                              Get.back();
                            },
                          ),
                        ),
                        const Divider(height: 0),
                        ListTile(
                          leading: const Icon(Icons.camera_enhance),
                          title: const Text('Kamera'),
                          onTap: () async {
                            var status = await Permission.camera.status;
                            if (status.isDenied) {
                              if (await Permission.camera.request().isGranted) {
                                controller.getFotoTiket(ImageSource.camera);
                              } else {
                                openAppSettings();
                              }
                            } else {
                              controller.getFotoTiket(ImageSource.camera);
                            }
                            Get.back();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.image),
                          title: const Text('Galeri'),
                          onTap: () async {
                            var status = await Permission.storage.status;
                            if (status.isDenied) {
                              if (await Permission.storage
                                  .request()
                                  .isGranted) {
                                controller.getFotoTiket(ImageSource.gallery);
                              } else {
                                openAppSettings();
                              }
                            } else {
                              controller.getFotoTiket(ImageSource.gallery);
                            }
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (controller.listSpuTiket!.isNotEmpty)
                GridView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1 / 1,
                  ),
                  itemCount: controller.listSpuTiket?.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = controller.listSpuTiket?[index];
                    return FotoTiket(
                      imageFile: item?.fotoTiketFile,
                      imageUrl: item?.fotoTiket,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class FotoTiket extends GetView<SpuController> {
  const FotoTiket({
    super.key,
    this.imageFile,
    this.imageUrl,
  });

  final File? imageFile;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpuController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5),
                      ),
                    ),
                    child: imageFile != null
                        ? Image.file(
                            imageFile!,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            key: UniqueKey(),
                            fit: BoxFit.cover,
                            imageUrl: imageUrl ?? "",
                            placeholder: (context, url) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return const Icon(Icons.image);
                            },
                            cacheManager: CacheManager(
                              Config(
                                "foto_tiket",
                                stalePeriod: const Duration(days: 3),
                              ),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Icon(
                        Icons.delete,
                        size: 15,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    onTap: () {
                      if (imageFile != null) {
                        controller.listSpuTiket?.removeWhere(
                            (element) => element.fotoTiketFile == imageFile);
                      } else {
                        controller.listSpuTiket?.removeWhere(
                            (element) => element.fotoTiket == imageUrl);
                      }
                      controller.update();
                    },
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
