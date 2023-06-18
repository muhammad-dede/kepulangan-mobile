import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/widgets/no_data_found_widget.dart';
import 'package:kepulangan/app/widgets/simple_list_widget.dart';

import '../controllers/pihak_kedua_controller.dart';
import 'search_pihak_kedua_page.dart';

class PihakKeduaView extends GetView<PihakKeduaController> {
  const PihakKeduaView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('Pihak Kedua'),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchPihakKeduaPage(),
                );
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: controller.isLoading.isTrue
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : controller.listPihakKedua.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      await controller.getData();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: controller.listPihakKedua.length,
                      itemBuilder: (context, index) {
                        final item = controller.listPihakKedua[index];
                        return SimpleListWidget(
                          onTap: () async {
                            dynamic result = await Get.toNamed(
                                Routes.editPihakKedua,
                                arguments: item);
                            if (result != null) {
                              controller.getData();
                            }
                          },
                          leading: CircleAvatar(
                            child: Text("${index + 1}"),
                          ),
                          title: item.nama ?? "",
                          subtitle: item.noIdentitas ?? "",
                          trailing: PopupMenuButton(
                            itemBuilder: (context) {
                              return [
                                const PopupMenuItem(
                                  value: "edit",
                                  child: Text("Ubah"),
                                ),
                                if (AuthService.to.isAdmin.isTrue)
                                  const PopupMenuItem(
                                    value: "delete",
                                    child: Text("Hapus"),
                                  ),
                              ];
                            },
                            onSelected: (value) async {
                              if (value == "edit") {
                                dynamic result = await Get.toNamed(
                                    Routes.editPihakKedua,
                                    arguments: item);
                                if (result != null) {
                                  controller.getData();
                                }
                              } else if (value == "delete") {
                                Get.dialog(
                                  AlertDialog(
                                    title: const Text('Hapus'),
                                    content: Text(
                                        'Apa anda yakin ingin menghapus "${item.nama ?? ""}"?'),
                                    actions: [
                                      TextButton(
                                        child: const Text('Ya'),
                                        onPressed: () async {
                                          Get.back();
                                          await controller.destroy(item);
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Tidak'),
                                        onPressed: () {
                                          Get.back();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  )
                : NoDataFoundWidget(
                    text: "Belum ada data",
                    onPressed: () async {
                      await controller.loadData();
                    },
                  ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "create_pihak_kedua",
          label: const Text('Tambah'),
          onPressed: () async {
            dynamic result = await Get.toNamed(Routes.createPihakKedua);
            if (result != null) {
              controller.getData();
            }
          },
        ),
      ),
    );
  }
}
