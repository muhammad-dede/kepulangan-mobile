import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/user.dart';
import 'package:kepulangan/app/modules/pengguna/controllers/pengguna_controller.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/widgets/no_data_found_widget.dart';
import 'package:kepulangan/app/widgets/simple_list_widget.dart';

class SearchPenggunaPage extends SearchDelegate {
  SearchPenggunaPage() : super(searchFieldLabel: "Cari ...");

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
    final List<User> listResult = PenggunaController.to.listPengguna
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
                  Get.toNamed(Routes.editPengguna, arguments: item);
                },
                leading: CircleAvatar(
                  child: Text("${index + 1}"),
                ),
                title: item.nama ?? "-",
                subtitle: item.email ?? "-",
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
                      Get.toNamed(Routes.editPengguna, arguments: item);
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
                                await PenggunaController.to.destroy(item);
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
    final List<User> listSuggestion = PenggunaController.to.listPengguna
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
                  Get.toNamed(Routes.editPengguna, arguments: item);
                },
                leading: CircleAvatar(
                  child: Text("${index + 1}"),
                ),
                title: item.nama ?? "-",
                subtitle: item.email ?? "-",
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
                      Get.toNamed(Routes.editPengguna, arguments: item);
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
                                await PenggunaController.to.destroy(item);
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
