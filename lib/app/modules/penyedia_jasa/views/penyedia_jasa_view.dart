import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/widgets/no_data_found_widget.dart';
import 'package:kepulangan/app/widgets/simple_list_widget.dart';

import '../controllers/penyedia_jasa_controller.dart';
import 'search_penyedia_jasa_page.dart';

class PenyediaJasaView extends GetView<PenyediaJasaController> {
  const PenyediaJasaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('Penyedia Jasa'),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchPenyediaJasaPage(),
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
            : controller.listPenyediaJasa.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      await controller.getData();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: controller.listPenyediaJasa.length,
                      itemBuilder: (context, index) {
                        final item = controller.listPenyediaJasa[index];
                        return SimpleListWidget(
                          onTap: () async {
                            dynamic result = await Get.toNamed(
                                Routes.editPenyediaJasa,
                                arguments: item);
                            if (result != null) {
                              controller.getData();
                            }
                          },
                          leading: CircleAvatar(
                            child: Text("${index + 1}"),
                          ),
                          title: item.namaPerusahaan ?? "",
                          subtitle: item.up ?? "",
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
                                    Routes.editPenyediaJasa,
                                    arguments: item);
                                if (result != null) {
                                  controller.getData();
                                }
                              } else if (value == "delete") {
                                Get.dialog(
                                  AlertDialog(
                                    title: const Text('Hapus'),
                                    content: Text(
                                        'Apa anda yakin ingin menghapus "${item.namaPerusahaan ?? ""}"?'),
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
          heroTag: "create_penyedia_jasa",
          label: const Text('Tambah'),
          onPressed: () async {
            dynamic result = await Get.toNamed(Routes.createPenyediaJasa);
            if (result != null) {
              controller.getData();
            }
          },
        ),
      ),
    );
  }
}
