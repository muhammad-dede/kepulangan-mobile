import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/widgets/no_data_found_widget.dart';
import 'package:kepulangan/app/widgets/simple_list_widget.dart';

import '../controllers/pengguna_controller.dart';
import 'search_pengguna_page.dart';

class PenggunaView extends GetView<PenggunaController> {
  const PenggunaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('Pengguna'),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchPenggunaPage(),
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
            : controller.listPengguna.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      await controller.getData();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: controller.listPengguna.length,
                      itemBuilder: (context, index) {
                        final item = controller.listPengguna[index];
                        return SimpleListWidget(
                          onTap: () async {
                            dynamic result = await Get.toNamed(
                                Routes.editPengguna,
                                arguments: item);
                            if (result != null) {
                              controller.getData();
                            }
                          },
                          leading: CircleAvatar(
                            child: Text("${index + 1}"),
                          ),
                          title: item.nama ?? "",
                          subtitle: item.email ?? "",
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
                                    Routes.editPengguna,
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
          heroTag: "create_pengguna",
          label: const Text('Tambah'),
          onPressed: () async {
            dynamic result = await Get.toNamed(Routes.createPengguna);
            if (result != null) {
              controller.getData();
            }
          },
        ),
      ),
    );
  }
}
