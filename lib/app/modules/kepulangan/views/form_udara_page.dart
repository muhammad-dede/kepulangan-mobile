import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/bast_udara.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/permission_service.dart';
import 'package:kepulangan/app/widgets/list_detail_widget.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';
import 'package:kepulangan/app/widgets/image_picker_widget.dart';

import '../controllers/kepulangan_controller.dart';

class FormUdaraPage extends GetView<KepulanganController> {
  const FormUdaraPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Header(),
        InputBastUdara(),
        InputFotoBoardingPass(),
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

class InputBastUdara extends GetView<KepulanganController> {
  const InputBastUdara({super.key});

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
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text("Fasilitas Udara"),
                subtitle: const Text("Pilih Fasilitas Udara"),
                trailing: GestureDetector(
                  onTap: () async {
                    dynamic result = await Get.toNamed(Routes.createBastUdara);
                    if (result != null) {
                      controller.bastUdara = result as BastUdara;
                    } else {
                      controller.bastUdara = controller.bastUdara;
                    }
                    controller.update();
                  },
                  child: const CircleAvatar(
                      child: Icon(Icons.person_add_alt_outlined)),
                ),
                onTap: () {
                  controller.getBastUdara();
                  showBastUdara();
                },
              ),
              if (controller.bastUdara != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      const Divider(),
                      ListDetailWidget(
                        title: "Purchase Order",
                        subtitle: controller.bastUdara?.purchaseOrder ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Nama Penyedia Jasa",
                        subtitle: controller
                                .bastUdara?.penyediaJasa?.namaPerusahaan ??
                            "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Lokasi Jemput",
                        subtitle: controller.bastUdara?.alamat?.lokasi ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Durasi Pengerjaan",
                        subtitle: controller.bastUdara?.durasiPengerjaan != null
                            ? "${controller.bastUdara?.durasiPengerjaan} hari pengerjaan"
                            : "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Tanggal Serah Terima",
                        subtitle:
                            controller.bastUdara?.tanggalSerahTerima != null
                                ? DateFormat('dd MMMM yyyy', "id_ID")
                                    .format(DateTime.parse(controller
                                        .bastUdara!.tanggalSerahTerima
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

void showBastUdara() {
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
                      controller.listBastUdara = controller.listAllBastUdara!
                          .where((item) =>
                              item.purchaseOrder!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              item.penyediaJasa!.namaPerusahaan!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                          .toList();
                    } else {
                      controller.listBastUdara = controller.listAllBastUdara;
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
                    : controller.listBastUdara!.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.listBastUdara?.length,
                            itemBuilder: (context, index) {
                              final item = controller.listBastUdara?[index];
                              return ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(item?.purchaseOrder ?? ""),
                                subtitle: Text(
                                    item?.penyediaJasa?.namaPerusahaan ?? ""),
                                trailing: controller.bastUdara?.id == item?.id
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )
                                    : const Icon(Icons.check_circle_outline),
                                onTap: () {
                                  if (controller.bastUdara != null) {
                                    controller.bastUdara = null;
                                  } else {
                                    controller.bastUdara = item;
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
                                    controller.getBastUdara();
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

class InputFotoBoardingPass extends GetView<KepulanganController> {
  const InputFotoBoardingPass({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KepulanganController>(
      builder: (controller) {
        return ImagePickerWidget(
          title: "Foto Boarding Pass",
          imageFile: controller.fotoBoardingPass,
          imageNetwork: controller.fotoBoardingPassOld,
          onDelete: () {
            controller.fotoBoardingPass = null;
            controller.update();
          },
          onTapCamera: () async {
            await PermissionService.to.cameraRequest().then((value) {
              if (value == true) {
                controller.getFotoBoardingPass(ImageSource.camera);
              }
            });
            Get.back();
          },
          onTapGalery: () async {
            await PermissionService.to.storageRequest().then((value) {
              if (value == true) {
                controller.getFotoBoardingPass(ImageSource.gallery);
              }
            });
            Get.back();
          },
        );
      },
    );
  }
}
