import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/penyedia_jasa.dart';
import 'package:kepulangan/app/modules/penyedia_jasa/controllers/penyedia_jasa_controller.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/widgets/no_data_found_widget.dart';
import 'package:kepulangan/app/widgets/simple_list_widget.dart';

class SearchPenyediaJasaPage extends SearchDelegate {
  SearchPenyediaJasaPage() : super(searchFieldLabel: "Cari ...");

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
    final List<PenyediaJasa> listResult = PenyediaJasaController
        .to.listPenyediaJasa
        .where((item) =>
            item.namaPerusahaan!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return listResult.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: listResult.length,
            itemBuilder: (context, index) {
              final item = listResult[index];
              return SimpleListWidget(
                onTap: () async {
                  close(context, null);
                  dynamic result = await Get.toNamed(Routes.editPenyediaJasa,
                      arguments: item);
                  if (result != null) {
                    PenyediaJasaController.to.getData();
                  }
                },
                leading: CircleAvatar(
                  child: Text("${index + 1}"),
                ),
                title: item.namaPerusahaan ?? "-",
                subtitle: item.up ?? "-",
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
                      close(context, null);
                      dynamic result = await Get.toNamed(
                          Routes.editPenyediaJasa,
                          arguments: item);
                      if (result != null) {
                        PenyediaJasaController.to.getData();
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
                                close(context, null);
                                await PenyediaJasaController.to.destroy(item);
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
    final List<PenyediaJasa> listSuggestion = PenyediaJasaController
        .to.listPenyediaJasa
        .where((item) =>
            item.namaPerusahaan!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return listSuggestion.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: listSuggestion.length,
            itemBuilder: (context, index) {
              final item = listSuggestion[index];
              return SimpleListWidget(
                onTap: () async {
                  close(context, null);
                  dynamic result = await Get.toNamed(Routes.editPenyediaJasa,
                      arguments: item);
                  if (result != null) {
                    PenyediaJasaController.to.getData();
                  }
                },
                leading: CircleAvatar(
                  child: Text("${index + 1}"),
                ),
                title: item.namaPerusahaan ?? "-",
                subtitle: item.up ?? "-",
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
                      close(context, null);
                      dynamic result = await Get.toNamed(
                          Routes.editPenyediaJasa,
                          arguments: item);
                      if (result != null) {
                        PenyediaJasaController.to.getData();
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
                                close(context, null);
                                await PenyediaJasaController.to.destroy(item);
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
