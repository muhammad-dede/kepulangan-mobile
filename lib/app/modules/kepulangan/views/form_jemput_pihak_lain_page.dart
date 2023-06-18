import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/bast_pihak_lain.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/widgets/list_detail_widget.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';

import '../controllers/kepulangan_controller.dart';

class FormJemputPihakLainPage extends GetView<KepulanganController> {
  const FormJemputPihakLainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Header(),
        InputBastPihakLain(),
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

class InputBastPihakLain extends GetView<KepulanganController> {
  const InputBastPihakLain({
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
                    dynamic result =
                        await Get.toNamed(Routes.createBastPihakLain);
                    if (result != null) {
                      controller.bastPihakLain = result as BastPihakLain;
                    } else {
                      controller.bastPihakLain = controller.bastPihakLain;
                    }
                    controller.update();
                  },
                  child: const CircleAvatar(
                      child: Icon(Icons.person_add_alt_outlined)),
                ),
                onTap: () {
                  controller.getBastPihakLain();
                  showBastPihakLain();
                },
              ),
              if (controller.bastPihakLain != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      const Divider(),
                      ListDetailWidget(
                        title: "Nama Pihak Kedua",
                        subtitle:
                            controller.bastPihakLain?.pihakKedua?.nama ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "No. Identitas Pihak Kedua",
                        subtitle:
                            controller.bastPihakLain?.pihakKedua?.noIdentitas ??
                                "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Jabatan Pihak Kedua",
                        subtitle:
                            controller.bastPihakLain?.pihakKedua?.jabatan ??
                                "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Instansi Pihak Kedua",
                        subtitle:
                            controller.bastPihakLain?.pihakKedua?.instansi ??
                                "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Alamat Pihak Kedua",
                        subtitle:
                            controller.bastPihakLain?.pihakKedua?.alamat ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "No. Telepon Pihak Kedua",
                        subtitle:
                            controller.bastPihakLain?.pihakKedua?.noTelp ?? "-",
                      ),
                      const Divider(),
                      ListDetailWidget(
                        title: "Tanggal Serah Terima",
                        subtitle:
                            controller.bastPihakLain?.tanggalSerahTerima != null
                                ? DateFormat('dd MMMM yyyy', "id_ID")
                                    .format(DateTime.parse(controller
                                        .bastPihakLain!.tanggalSerahTerima
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

void showBastPihakLain() {
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
                      controller.listBastPihakLain = controller
                          .listAllBastPihakLain!
                          .where((item) =>
                              item.pihakKedua!.nama!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              item.pihakKedua!.noIdentitas!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                          .toList();
                    } else {
                      controller.listBastPihakLain =
                          controller.listAllBastPihakLain;
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
                    : controller.listBastPihakLain!.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.listBastPihakLain?.length,
                            itemBuilder: (context, index) {
                              final item = controller.listBastPihakLain?[index];
                              return ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(item?.pihakKedua?.nama ?? ""),
                                subtitle: Text(item?.tanggalSerahTerima != null
                                    ? DateFormat('dd MMMM yyyy', 'id_ID')
                                        .format(DateTime.parse(item!
                                            .tanggalSerahTerima
                                            .toString()))
                                        .toString()
                                    : ""),
                                trailing: controller.bastPihakLain?.id ==
                                        item?.id
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )
                                    : const Icon(Icons.check_circle_outline),
                                onTap: () {
                                  if (controller.bastPihakLain != null) {
                                    controller.bastPihakLain = null;
                                  } else {
                                    controller.bastPihakLain = item;
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
                                    controller.getBastPihakLain();
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
