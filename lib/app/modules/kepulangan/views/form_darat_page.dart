import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/bast_darat.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/permission_service.dart';
import 'package:kepulangan/app/widgets/list_detail_widget.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';
import 'package:kepulangan/app/widgets/image_picker_widget.dart';

import '../controllers/kepulangan_controller.dart';

class FormDaratPage extends GetView<KepulanganController> {
  const FormDaratPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Header(),
        InputBastDarat(),
        InputFotoBast(),
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

class InputBastDarat extends GetView<KepulanganController> {
  const InputBastDarat({
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
                title: const Text("Fasilitas Darat"),
                subtitle: const Text("Pilih Fasilitas Darat"),
                trailing: GestureDetector(
                  onTap: () async {
                    dynamic result = await Get.toNamed(Routes.createBastDarat);
                    if (result != null) {
                      controller.bastDarat = result as BastDarat;
                    } else {
                      controller.bastDarat = controller.bastDarat;
                    }
                    controller.update();
                  },
                  child: const CircleAvatar(
                      child: Icon(Icons.person_add_alt_outlined)),
                ),
                onTap: () {
                  controller.getBastDarat();
                  showBastDarat();
                },
              ),
              if (controller.bastDarat != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      const Divider(),
                      ListDetailWidget(
                        title: "Purchase Order",
                        subtitle: controller.bastDarat?.purchaseOrder ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Nama Penyedia Jasa",
                        subtitle: controller
                                .bastDarat?.penyediaJasa?.namaPerusahaan ??
                            "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Lokasi Jemput",
                        subtitle: controller.bastDarat?.alamat?.lokasi ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Durasi Pengerjaan",
                        subtitle: controller.bastDarat?.durasiPengerjaan != null
                            ? "${controller.bastDarat?.durasiPengerjaan} hari pengerjaan"
                            : "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Tanggal Serah Terima",
                        subtitle:
                            controller.bastDarat?.tanggalSerahTerima != null
                                ? DateFormat('dd MMMM yyyy', "id_ID")
                                    .format(DateTime.parse(controller
                                        .bastDarat!.tanggalSerahTerima
                                        .toString()))
                                    .toString()
                                : "-",
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

class InputFotoBast extends GetView<KepulanganController> {
  const InputFotoBast({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KepulanganController>(
      builder: (controller) {
        return ImagePickerWidget(
          title: "Foto BAST",
          imageFile: controller.fotoBast,
          imageNetwork: controller.fotoBastOld,
          onDelete: () {
            controller.fotoBast = null;
            controller.update();
          },
          onTapCamera: () async {
            await PermissionService.to.cameraRequest().then((value) {
              if (value == true) {
                controller.getFotoBast(ImageSource.camera);
              }
            });
            Get.back();
          },
          onTapGalery: () async {
            await PermissionService.to.storageRequest().then((value) {
              if (value == true) {
                controller.getFotoBast(ImageSource.gallery);
              }
            });
            Get.back();
          },
        );
      },
    );
  }
}

void showBastDarat() {
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
                      controller.listBastDarat = controller.listAllBastDarat!
                          .where((item) =>
                              item.purchaseOrder!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              item.penyediaJasa!.namaPerusahaan!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                          .toList();
                    } else {
                      controller.listBastDarat = controller.listAllBastDarat;
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
                    : controller.listBastDarat!.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.listBastDarat?.length,
                            itemBuilder: (context, index) {
                              final item = controller.listBastDarat?[index];
                              return ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(item?.purchaseOrder ?? ""),
                                subtitle: Text(
                                    item?.penyediaJasa?.namaPerusahaan ?? ""),
                                trailing: controller.bastDarat?.id == item?.id
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )
                                    : const Icon(Icons.check_circle_outline),
                                onTap: () {
                                  if (controller.bastDarat != null) {
                                    controller.bastDarat = null;
                                  } else {
                                    controller.bastDarat = item;
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
                                    controller.getBastDarat();
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
