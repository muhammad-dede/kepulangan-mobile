import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/bast_makan.dart';
import 'package:kepulangan/app/modules/bast_makan/controllers/bast_makan_controller.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/base_client.dart';
import 'package:kepulangan/app/widgets/complex_list_widget.dart';
import 'package:kepulangan/app/widgets/error_exception_widget.dart';
import 'package:kepulangan/app/widgets/no_data_found_widget.dart';

class SearchBastMakanPage extends SearchDelegate {
  SearchBastMakanPage() : super(searchFieldLabel: "Cari ...");

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
    return FutureBuilder<List<BastMakan>>(
      future: BastMakanController.to.search(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (BastMakanController.to.listSearch.isEmpty) {
            return const NoDataFoundWidget(text: "Data tidak ditemukan");
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: BastMakanController.to.listSearch.length,
            itemBuilder: (context, index) {
              final item = BastMakanController.to.listSearch[index];
              return ComplexListWidget(
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.detailBastMakan, arguments: item);
                },
                footerLeftText:
                    "${item.tanggalSerahTerima != null ? DateFormat('dd-MM-yyyy', "id_ID").format(DateTime.parse(item.tanggalSerahTerima.toString())) : "-"} (${item.waktuSerahTerima ?? "-"})",
                footerRightText: item.terlaksana == 0 ? "Proses" : "Terlaksana",
                leading: const CircleAvatar(
                  child: Icon(Icons.article_outlined),
                ),
                titleText: item.purchaseOrder ?? "-",
                subTitleText: item.penyediaJasa?.namaPerusahaan ?? "-",
                trailing: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      if (BastMakanController.to.isShowTerlaksana(item))
                        const PopupMenuItem(
                          value: "terlaksana",
                          child: Text("Terlaksana"),
                        ),
                      if (BastMakanController.to.isShowExport(item))
                        const PopupMenuItem(
                          value: "export",
                          child: Text("Export"),
                        ),
                      const PopupMenuItem(
                        value: "detail",
                        child: Text("Detail"),
                      ),
                      if (BastMakanController.to.isShowEdit(item))
                        const PopupMenuItem(
                          value: "ubah",
                          child: Text("Ubah"),
                        ),
                      if (BastMakanController.to.isShowDelete(item))
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
    return FutureBuilder<List<BastMakan>>(
      future: BastMakanController.to.search(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (BastMakanController.to.listSearch.isEmpty) {
            return const NoDataFoundWidget(text: "Data tidak ditemukan");
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: BastMakanController.to.listSearch.length,
            itemBuilder: (context, index) {
              final item = BastMakanController.to.listSearch[index];
              return ComplexListWidget(
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.detailBastMakan, arguments: item);
                },
                footerLeftText:
                    "${item.tanggalSerahTerima != null ? DateFormat('dd-MM-yyyy', "id_ID").format(DateTime.parse(item.tanggalSerahTerima.toString())) : "-"} (${item.waktuSerahTerima ?? "-"})",
                footerRightText: item.terlaksana == 0 ? "Proses" : "Terlaksana",
                leading: const CircleAvatar(
                  child: Icon(Icons.article_outlined),
                ),
                titleText: item.purchaseOrder ?? "-",
                subTitleText: item.penyediaJasa?.namaPerusahaan ?? "-",
                trailing: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      if (BastMakanController.to.isShowTerlaksana(item))
                        const PopupMenuItem(
                          value: "terlaksana",
                          child: Text("Terlaksana"),
                        ),
                      if (BastMakanController.to.isShowExport(item))
                        const PopupMenuItem(
                          value: "export",
                          child: Text("Export"),
                        ),
                      const PopupMenuItem(
                        value: "detail",
                        child: Text("Detail"),
                      ),
                      if (BastMakanController.to.isShowEdit(item))
                        const PopupMenuItem(
                          value: "ubah",
                          child: Text("Ubah"),
                        ),
                      if (BastMakanController.to.isShowDelete(item))
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

void actionTerlaksana(BastMakan item) {
  Get.dialog(
    AlertDialog(
      title: const Text('Terlaksana'),
      content: Text(
          'Anda yakin ingin mengubah status "${item.purchaseOrder ?? ""}" menjadi terlaksana?'),
      actions: [
        TextButton(
          child: const Text('Ya'),
          onPressed: () async {
            Get.back();
            await BastMakanController.to.terlaksana(item);
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

void actionExport(context, BastMakan item) {
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
          title: const Text("Berita Acara Serah Terima Makan"),
          onTap: () {
            Get.back();
            Get.back();
            Get.toNamed(
              Routes.pdf,
              arguments: {
                "title": "Berita Acara Serah Terima Makan",
                "stream_url":
                    "${BaseClient.apiUrl}/api/pdf/bast-makan/${item.id}?download=false",
                "download_url":
                    "${BaseClient.apiUrl}/api/pdf/bast-makan/${item.id}?download=true"
              },
            );
          },
        ),
      ],
    ),
  );
}

void actionDetail(BastMakan item) {
  Get.back();
  Get.toNamed(Routes.detailBastMakan, arguments: item);
}

void actionUbah(BastMakan item) {
  Get.back();
  Get.toNamed(Routes.editBastMakan, arguments: item);
}

void actionHapus(BastMakan item) {
  Get.dialog(
    AlertDialog(
      title: const Text('Hapus'),
      content:
          Text('Anda yakin ingin menghapus "${item.purchaseOrder ?? ""}"?'),
      actions: [
        TextButton(
          child: const Text('Ya'),
          onPressed: () async {
            Get.back();
            await BastMakanController.to.destroy(item);
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
