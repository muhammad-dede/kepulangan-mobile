import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/bast_pihak_lain.dart';
import 'package:kepulangan/app/modules/bast_pihak_lain/controllers/bast_pihak_lain_controller.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/base_client.dart';
import 'package:kepulangan/app/widgets/complex_list_widget.dart';
import 'package:kepulangan/app/widgets/error_exception_widget.dart';
import 'package:kepulangan/app/widgets/no_data_found_widget.dart';

class SearchBastPihakLainPage extends SearchDelegate {
  SearchBastPihakLainPage() : super(searchFieldLabel: "Cari ...");

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
    return FutureBuilder<List<BastPihakLain>>(
      future: BastPihakLainController.to.search(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (BastPihakLainController.to.listSearch.isEmpty) {
            return const NoDataFoundWidget(text: "Data tidak ditemukan");
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: BastPihakLainController.to.listSearch.length,
            itemBuilder: (context, index) {
              final item = BastPihakLainController.to.listSearch[index];
              return ComplexListWidget(
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.detailBastPihakLain, arguments: item);
                },
                footerLeftText: item.tanggalSerahTerima != null
                    ? DateFormat('dd-MM-yyyy', "id_ID").format(
                        DateTime.parse(item.tanggalSerahTerima.toString()))
                    : "",
                footerRightText: item.terlaksana == 0 ? "Proses" : "Terlaksana",
                leading: const CircleAvatar(
                  child: Icon(Icons.article_outlined),
                ),
                titleText: item.pihakKedua?.nama ?? "-",
                subTitleText: "Jumlah: ${item.jemputPihakLain?.length} PMI",
                trailing: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      if (BastPihakLainController.to.isCanTerlaksana(item))
                        const PopupMenuItem(
                          value: "terlaksana",
                          child: Text("Terlaksana"),
                        ),
                      if (BastPihakLainController.to.isCanExport(item))
                        const PopupMenuItem(
                          value: "export",
                          child: Text("Export"),
                        ),
                      const PopupMenuItem(
                        value: "detail",
                        child: Text("Detail"),
                      ),
                      if (BastPihakLainController.to.isCanEdit(item))
                        const PopupMenuItem(
                          value: "ubah",
                          child: Text("Ubah"),
                        ),
                      if (BastPihakLainController.to.isCanDelete(item))
                        const PopupMenuItem(
                          value: "hapus",
                          child: Text("Hapus"),
                        ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 'terlaksana') {
                      actionTerlaksana(item);
                    }
                    if (value == 'export') {
                      actionExport(context, item);
                    }
                    if (value == 'detail') {
                      actionDetail(item);
                    }
                    if (value == 'ubah') {
                      actionUbah(item);
                    }
                    if (value == 'hapus') {
                      actionHapus(item);
                    }
                  },
                ),
              );
            },
          );
        }
        if (snapshot.hasError) {
          return ErrorExceptionWidget(text: snapshot.error.toString());
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<BastPihakLain>>(
      future: BastPihakLainController.to.search(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (BastPihakLainController.to.listSearch.isEmpty) {
            return const NoDataFoundWidget(text: "Data tidak ditemukan");
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: BastPihakLainController.to.listSearch.length,
            itemBuilder: (context, index) {
              final item = BastPihakLainController.to.listSearch[index];
              return ComplexListWidget(
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.detailBastPihakLain, arguments: item);
                },
                footerLeftText: item.tanggalSerahTerima != null
                    ? DateFormat('dd-MM-yyyy', "id_ID").format(
                        DateTime.parse(item.tanggalSerahTerima.toString()))
                    : "",
                footerRightText: item.terlaksana == 0 ? "Proses" : "Terlaksana",
                leading: const CircleAvatar(
                  child: Icon(Icons.article_outlined),
                ),
                titleText: item.pihakKedua?.nama ?? "-",
                subTitleText: "Jumlah: ${item.jemputPihakLain?.length} PMI",
                trailing: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      if (BastPihakLainController.to.isCanTerlaksana(item))
                        const PopupMenuItem(
                          value: "terlaksana",
                          child: Text("Terlaksana"),
                        ),
                      if (BastPihakLainController.to.isCanExport(item))
                        const PopupMenuItem(
                          value: "export",
                          child: Text("Export"),
                        ),
                      const PopupMenuItem(
                        value: "detail",
                        child: Text("Detail"),
                      ),
                      if (BastPihakLainController.to.isCanEdit(item))
                        const PopupMenuItem(
                          value: "ubah",
                          child: Text("Ubah"),
                        ),
                      if (BastPihakLainController.to.isCanDelete(item))
                        const PopupMenuItem(
                          value: "hapus",
                          child: Text("Hapus"),
                        ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 'terlaksana') {
                      actionTerlaksana(item);
                    }
                    if (value == 'export') {
                      actionExport(context, item);
                    }
                    if (value == 'detail') {
                      actionDetail(item);
                    }
                    if (value == 'ubah') {
                      actionUbah(item);
                    }
                    if (value == 'hapus') {
                      actionHapus(item);
                    }
                  },
                ),
              );
            },
          );
        }
        if (snapshot.hasError) {
          return ErrorExceptionWidget(text: snapshot.error.toString());
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

void actionTerlaksana(BastPihakLain item) {
  Get.dialog(
    AlertDialog(
      title: const Text('Terlaksana'),
      content: Text(
          'Anda yakin ingin mengubah status "${item.pihakKedua?.nama ?? ""}" menjadi terlaksana?'),
      actions: [
        TextButton(
          child: const Text('Ya'),
          onPressed: () async {
            Get.back();
            await BastPihakLainController.to.terlaksana(item);
            Get.back();
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

void actionExport(context, BastPihakLain item) {
  Get.bottomSheet(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(10),
      ),
    ),
    Wrap(
      children: [
        ListTile(
          title: const Text(
            'Pilih Export',
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
        ListTile(
          title: const Text("Berita Acara Serah Terima PMI"),
          onTap: () {
            Get.back();
            Get.back();
            Get.toNamed(
              Routes.pdf,
              arguments: {
                "title": "Berita Acara Serah Terima PMI",
                "stream_url":
                    "${BaseClient.apiUrl}/api/pdf/bast-pihak-lain/${item.id}?download=false",
                "download_url":
                    "${BaseClient.apiUrl}/api/pdf/bast-pihak-lain/${item.id}?download=true"
              },
            );
          },
        ),
      ],
    ),
  );
}

void actionDetail(BastPihakLain item) {
  Get.back();
  Get.toNamed(Routes.detailBastPihakLain, arguments: item);
}

void actionUbah(BastPihakLain item) {
  Get.back();
  Get.toNamed(Routes.editBastPihakLain, arguments: item);
}

void actionHapus(BastPihakLain item) {
  Get.dialog(
    AlertDialog(
      title: const Text('Hapus'),
      content:
          Text('Anda yakin ingin menghapus "${item.pihakKedua?.nama ?? ""}"?'),
      actions: [
        TextButton(
          child: const Text('Ya'),
          onPressed: () async {
            Get.back();
            await BastPihakLainController.to.destroy(item);
            Get.back();
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
