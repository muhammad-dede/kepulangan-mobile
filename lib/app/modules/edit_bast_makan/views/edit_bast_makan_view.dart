import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/data/models/makan.dart';
import 'package:kepulangan/app/widgets/date_picker_widget.dart';
import 'package:kepulangan/app/widgets/image_picker_widget.dart';
import 'package:kepulangan/app/widgets/list_detail_widget.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/edit_bast_makan_controller.dart';

class EditBastMakanView extends GetView<EditBastMakanController> {
  const EditBastMakanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fasilitas Makan"),
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
            InputTanggaSerahTerima(),
            InputWaktuSerahTerima(),
            InputDurasiPengerjaan(),
            InputMakan(),
            InputFotoPenyediaJasa(),
            InputFotoSerahTerima(),
            InputFotoInvoice(),
          ],
        ),
      ),
    );
  }
}

class InputPurchaseOrder extends GetView<EditBastMakanController> {
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

class InputPenyediaJasa extends GetView<EditBastMakanController> {
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
            GetBuilder<EditBastMakanController>(
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
                          : controller.listPenyediaJasa!.isNotEmpty
                              ? ListView.builder(
                                  itemCount:
                                      controller.listPenyediaJasa!.length,
                                  itemBuilder: (context, index) {
                                    final item =
                                        controller.listPenyediaJasa![index];
                                    return ListTile(
                                      title: Text(item.namaPerusahaan ?? ""),
                                      subtitle: Text(item.up ?? "-"),
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

class InputAlamat extends GetView<EditBastMakanController> {
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
            GetBuilder<EditBastMakanController>(
              builder: (controller) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Pilih Alamat',
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
                          : controller.listAlamat!.isNotEmpty
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

class InputTanggaSerahTerima extends GetView<EditBastMakanController> {
  const InputTanggaSerahTerima({
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

class InputDurasiPengerjaan extends GetView<EditBastMakanController> {
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
            GetBuilder<EditBastMakanController>(
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
                            title: Text(item['title'] ?? ""),
                            trailing:
                                controller.durasiPengerjaan == item['value']
                                    ? const Icon(Icons.check)
                                    : null,
                            onTap: () {
                              controller.durasiPengerjaan = item['value'];
                              controller.durasiPengerjaanController.text =
                                  item['title'] ?? "";
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

class InputWaktuSerahTerima extends GetView<EditBastMakanController> {
  const InputWaktuSerahTerima({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Waktu Serah Terima",
        readOnly: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        controller: controller.waktuSerahTerimaController,
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
            GetBuilder<EditBastMakanController>(
              builder: (controller) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Pilih Waktu Serah Terima',
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
                        itemCount: controller.listWaktuSerahTerima.length,
                        itemBuilder: (context, index) {
                          final item = controller.listWaktuSerahTerima[index];
                          return ListTile(
                            title: Text(item['value'] ?? ""),
                            trailing:
                                controller.waktuSerahTerimaController.text ==
                                        item['value']
                                    ? const Icon(Icons.check)
                                    : null,
                            onTap: () {
                              controller.waktuSerahTerimaController.text =
                                  item['value'] ?? "";
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

class InputFotoPenyediaJasa extends GetView<EditBastMakanController> {
  const InputFotoPenyediaJasa({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditBastMakanController>(
      builder: (controller) {
        return ImagePickerWidget(
          title: "Foto Penyedia Jasa",
          imageFile: controller.fotoPenyediaJasa,
          imageNetwork: controller.fotoPenyediaJasaOld,
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

class InputFotoSerahTerima extends GetView<EditBastMakanController> {
  const InputFotoSerahTerima({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditBastMakanController>(
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

class InputFotoInvoice extends GetView<EditBastMakanController> {
  const InputFotoInvoice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditBastMakanController>(
      builder: (controller) {
        return ImagePickerWidget(
          title: "Foto Invoice",
          imageFile: controller.fotoInvoice,
          imageNetwork: controller.fotoInvoiceOld,
          onDelete: () {
            controller.fotoInvoice = null;
            controller.update();
          },
          onTapCamera: () async {
            var status = await Permission.camera.status;
            if (status.isDenied) {
              if (await Permission.camera.request().isGranted) {
                controller.getFotoInvoice(ImageSource.camera);
              } else {
                openAppSettings();
              }
            } else {
              controller.getFotoInvoice(ImageSource.camera);
            }
            Get.back();
          },
          onTapGalery: () async {
            var status = await Permission.storage.status;
            if (status.isDenied) {
              if (await Permission.storage.request().isGranted) {
                controller.getFotoInvoice(ImageSource.gallery);
              } else {
                openAppSettings();
              }
            } else {
              controller.getFotoInvoice(ImageSource.gallery);
            }
            Get.back();
          },
        );
      },
    );
  }
}

class InputMakan extends GetView<EditBastMakanController> {
  const InputMakan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditBastMakanController>(
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
                subtitle: const Text("Pilih Data PMI"),
                onTap: () {
                  controller.getImigran();
                  showImigran();
                },
              ),
              if (controller.listMakan!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    children: controller.listMakan!.map(
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
    GetBuilder<EditBastMakanController>(
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
                                trailing: controller.listMakan!
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
                                  if (controller.listMakan!
                                      .where((element) =>
                                          element.imigran?.id == item!.id)
                                      .isNotEmpty) {
                                    controller.listMakan!.removeWhere(
                                        (element) =>
                                            element.imigran?.id == item?.id);
                                  } else {
                                    controller.listMakan!
                                        .add(Makan(imigran: item));
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
    GetBuilder<EditBastMakanController>(
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
