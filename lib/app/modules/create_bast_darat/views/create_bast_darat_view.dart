import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/darat.dart';
import 'package:kepulangan/app/widgets/date_picker_widget.dart';
import 'package:kepulangan/app/widgets/image_picker_widget.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/create_bast_darat_controller.dart';

class CreateBastDaratView extends GetView<CreateBastDaratController> {
  const CreateBastDaratView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fasilitas Darat"),
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
            InputPurchaseOrder(),
            InputPenyediaJasa(),
            InputAlamat(),
            InputTanggalSerahTerima(),
            InputDurasiPengerjaan(),
            InputDarat(),
            InputFotoPenyediaJasa(),
            InputFotoSerahTerima(),
          ],
        ),
      ),
    );
  }
}

class InputPurchaseOrder extends GetView<CreateBastDaratController> {
  const InputPurchaseOrder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Purchase Order",
        readOnly: false,
        controller: controller.purchaseOrderController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class InputPenyediaJasa extends GetView<CreateBastDaratController> {
  const InputPenyediaJasa({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Penyedia Jasa",
        readOnly: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        controller: controller.penyediaJasaController,
        obscureText: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () {
          controller.getPenyediaJasa();
          Get.bottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            GetBuilder<CreateBastDaratController>(
              builder: (controller) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Pilih Penyedia Jasa',
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
                            controller.listPenyediaJasa = controller
                                .listAllPenyediaJasa!
                                .where((item) => item.namaPerusahaan!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          } else {
                            controller.listPenyediaJasa =
                                controller.listAllPenyediaJasa;
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
                          : controller.listPenyediaJasa != null
                              ? ListView.builder(
                                  itemCount:
                                      controller.listPenyediaJasa!.length,
                                  itemBuilder: (context, index) {
                                    final item =
                                        controller.listPenyediaJasa![index];
                                    return ListTile(
                                      title: Text(item.namaPerusahaan ?? ""),
                                      trailing:
                                          controller.idPenyediaJasa == item.id
                                              ? const Icon(Icons.check)
                                              : null,
                                      onTap: () {
                                        controller.idPenyediaJasa = item.id;
                                        controller.penyediaJasaController.text =
                                            item.namaPerusahaan ?? "";
                                        controller.update();
                                        Get.back();
                                      },
                                    );
                                  },
                                )
                              : Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.getPenyediaJasa();
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

class InputAlamat extends GetView<CreateBastDaratController> {
  const InputAlamat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Alamat Serah Terima",
        readOnly: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        controller: controller.alamatController,
        obscureText: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () {
          controller.getAlamat();
          Get.bottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            GetBuilder<CreateBastDaratController>(
              builder: (controller) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Pilih Alamat Serah Terima',
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
                            controller.listAlamat = controller.listAllAlamat!
                                .where((item) => item.judul!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          } else {
                            controller.listAlamat = controller.listAllAlamat;
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
                          : controller.listAlamat != null
                              ? ListView.builder(
                                  itemCount: controller.listAlamat!.length,
                                  itemBuilder: (context, index) {
                                    final item = controller.listAlamat![index];
                                    return ListTile(
                                      title: Text(item.judul ?? ""),
                                      subtitle: Text(
                                        item.lokasi ?? "",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: controller.idAlamat == item.id
                                          ? const Icon(Icons.check)
                                          : null,
                                      onTap: () {
                                        controller.idAlamat = item.id;
                                        controller.alamatController.text =
                                            item.judul ?? "";
                                        controller.update();
                                        Get.back();
                                      },
                                    );
                                  },
                                )
                              : Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.getAlamat();
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

class InputTanggalSerahTerima extends GetView<CreateBastDaratController> {
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

class InputDurasiPengerjaan extends GetView<CreateBastDaratController> {
  const InputDurasiPengerjaan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Durasi Pengerjaan",
        readOnly: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        controller: controller.durasiPengerjaanController,
        obscureText: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () {
          Get.bottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            GetBuilder<CreateBastDaratController>(
              builder: (controller) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Pilih Durasi Pengerjaan',
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.listDurasiPengerjaan.length,
                        itemBuilder: (context, index) {
                          final item = controller.listDurasiPengerjaan[index];
                          return ListTile(
                            title: Text(item['durasi'] ?? ""),
                            trailing:
                                controller.durasiPengerjaan == item['value']
                                    ? const Icon(Icons.check)
                                    : null,
                            onTap: () {
                              controller.durasiPengerjaan = item['value'];
                              controller.durasiPengerjaanController.text =
                                  item['durasi'] ?? "";
                              controller.update();
                              Get.back();
                            },
                          );
                        },
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

class InputFotoPenyediaJasa extends GetView<CreateBastDaratController> {
  const InputFotoPenyediaJasa({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateBastDaratController>(
      builder: (controller) {
        return ImagePickerWidget(
          title: "Foto Penyedia Jasa",
          imageFile: controller.fotoPenyediaJasa,
          onDelete: () {
            controller.fotoPenyediaJasa = null;
            controller.update();
          },
          onTapCamera: () async {
            var status = await Permission.camera.status;
            if (status.isDenied) {
              if (await Permission.camera.request().isGranted) {
                controller.getFotoPenyediaJasa(ImageSource.camera);
              } else {
                openAppSettings();
              }
            } else {
              controller.getFotoPenyediaJasa(ImageSource.camera);
            }
            Get.back();
          },
          onTapGalery: () async {
            var status = await Permission.storage.status;
            if (status.isDenied) {
              if (await Permission.storage.request().isGranted) {
                controller.getFotoPenyediaJasa(ImageSource.gallery);
              } else {
                openAppSettings();
              }
            } else {
              controller.getFotoPenyediaJasa(ImageSource.gallery);
            }
            Get.back();
          },
        );
      },
    );
  }
}

class InputFotoSerahTerima extends GetView<CreateBastDaratController> {
  const InputFotoSerahTerima({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateBastDaratController>(
      builder: (controller) {
        return ImagePickerWidget(
          title: "Foto Serah Terima",
          imageFile: controller.fotoSerahTerima,
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

class InputDarat extends GetView<CreateBastDaratController> {
  const InputDarat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateBastDaratController>(
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
              for (var item in controller.listDarat!)
                ImagePickerWidget(
                  title: item.imigran?.nama ?? "",
                  subtitle: item.imigran?.paspor ?? "",
                  imageFile: item.fotoBastFile,
                  onDelete: () {
                    item.fotoBast = null;
                    controller.update();
                  },
                  onTapCamera: () async {
                    var status = await Permission.camera.status;
                    if (status.isDenied) {
                      if (await Permission.camera.request().isGranted) {
                        controller.getFotoBast(
                            ImageSource.camera, item.imigran!);
                      } else {
                        openAppSettings();
                      }
                    } else {
                      controller.getFotoBast(ImageSource.camera, item.imigran!);
                    }
                    Get.back();
                  },
                  onTapGalery: () async {
                    var status = await Permission.storage.status;
                    if (status.isDenied) {
                      if (await Permission.storage.request().isGranted) {
                        controller.getFotoBast(
                            ImageSource.gallery, item.imigran!);
                      } else {
                        openAppSettings();
                      }
                    } else {
                      controller.getFotoBast(
                          ImageSource.gallery, item.imigran!);
                    }
                    Get.back();
                  },
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
    GetBuilder<CreateBastDaratController>(
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
                                trailing: controller.listDarat!
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
                                  if (controller.listDarat!
                                      .where((element) =>
                                          element.imigran?.id == item!.id)
                                      .isNotEmpty) {
                                    controller.listDarat!.removeWhere(
                                        (element) =>
                                            element.imigran?.id == item?.id);
                                  } else {
                                    controller.listDarat!
                                        .add(Darat(imigran: item));
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
