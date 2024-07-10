import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/koordinator.dart';
import 'package:kepulangan/app/modules/koordinator/controllers/koordinator_controller.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/widgets/no_data_found_widget.dart';
import 'package:kepulangan/app/widgets/simple_list_widget.dart';

class SearchKoordinatorPage extends SearchDelegate {
  SearchKoordinatorPage() : super(searchFieldLabel: "Cari ...");

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Koordinator> listResult = KoordinatorController
        .to.listKoordinator
        .where((item) => item.nama!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return listResult.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: listResult.length,
            itemBuilder: (context, index) {
              final item = listResult[index];
              return SimpleListWidget(
                onTap: () {
                  close(context, null);
                  Get.toNamed(Routes.editKoordinator, arguments: item);
                },
                leading: CircleAvatar(
                  child: Text("${index + 1}"),
                ),
                title: item.nama ?? "-",
                subtitle: item.nip ?? "-",
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
                  onSelected: (value) {
                    if (value == "edit") {
                      close(context, null);
                      Get.toNamed(Routes.editKoordinator, arguments: item);
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
                                close(context, null);
                                await KoordinatorController.to.destroy(item);
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
          )
        : const NoDataFoundWidget(text: "Data tidak ditemukan");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Koordinator> listSuggestion = KoordinatorController
        .to.listKoordinator
        .where((item) => item.nama!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return listSuggestion.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: listSuggestion.length,
            itemBuilder: (context, index) {
              final item = listSuggestion[index];
              return SimpleListWidget(
                onTap: () {
                  close(context, null);
                  Get.toNamed(Routes.editKoordinator, arguments: item);
                },
                leading: CircleAvatar(
                  child: Text("${index + 1}"),
                ),
                title: item.nama ?? "-",
                subtitle: item.nip ?? "-",
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
                  onSelected: (value) {
                    if (value == "edit") {
                      close(context, null);
                      Get.toNamed(Routes.editKoordinator, arguments: item);
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
                                close(context, null);
                                await KoordinatorController.to.destroy(item);
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
          )
        : const NoDataFoundWidget(text: "Data tidak ditemukan");
  }
}
