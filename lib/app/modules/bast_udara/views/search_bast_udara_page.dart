import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/bast_udara.dart';
import 'package:kepulangan/app/modules/bast_udara/controllers/bast_udara_controller.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/base_client.dart';
import 'package:kepulangan/app/widgets/complex_list_widget.dart';
import 'package:kepulangan/app/widgets/error_exception_widget.dart';
import 'package:kepulangan/app/widgets/no_data_found_widget.dart';

class SearchBastUdaraPage extends SearchDelegate {
  SearchBastUdaraPage() : super(searchFieldLabel: "Cari ...");

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
    return FutureBuilder<List<BastUdara>>(
      future: BastUdaraController.to.search(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (BastUdaraController.to.listSearch.isEmpty) {
            return const NoDataFoundWidget(text: "Data tidak ditemukan");
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: BastUdaraController.to.listSearch.length,
            itemBuilder: (context, index) {
              final item = BastUdaraController.to.listSearch[index];
              return ComplexListWidget(
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.detailBastUdara, arguments: item);
                },
                footerLeftText: item.tanggalSerahTerima != null
                    ? DateFormat('dd-MM-yyyy', "id_ID").format(
                        DateTime.parse(item.tanggalSerahTerima.toString()))
                    : "",
                footerRightText: item.terlaksana == 0 ? "Proses" : "Terlaksana",
                leading: const CircleAvatar(
                  child: Icon(Icons.article_outlined),
                ),
                titleText: item.purchaseOrder ?? "-",
                subTitleText: item.penyediaJasa?.namaPerusahaan ?? "-",
                trailing: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      if (BastUdaraController.to.isShowTerlaksana(item))
                        const PopupMenuItem(
                          value: "terlaksana",
                          child: Text("Terlaksana"),
                        ),
                      if (BastUdaraController.to.isShowSpu(item))
                        const PopupMenuItem(
                          value: "spu",
                          child: Text("SPU"),
                        ),
                      if (BastUdaraController.to.isShowExportBastUdara(item) ||
                          BastUdaraController.to.isShowExportSpu(item))
                        const PopupMenuItem(
                          value: "export",
                          child: Text("Export"),
                        ),
                      const PopupMenuItem(
                        value: "detail",
                        child: Text("Detail"),
                      ),
                      if (BastUdaraController.to.isShowEdit(item))
                        const PopupMenuItem(
                          value: "ubah",
                          child: Text("Ubah"),
                        ),
                      if (BastUdaraController.to.isShowDelete(item))
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
                    if (value == 'spu') {
                      actionSpu(item);
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
    return FutureBuilder<List<BastUdara>>(
      future: BastUdaraController.to.search(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (BastUdaraController.to.listSearch.isEmpty) {
            return const NoDataFoundWidget(text: "Data tidak ditemukan");
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: BastUdaraController.to.listSearch.length,
            itemBuilder: (context, index) {
              final item = BastUdaraController.to.listSearch[index];
              return ComplexListWidget(
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.detailBastUdara, arguments: item);
                },
                footerLeftText: item.tanggalSerahTerima != null
                    ? DateFormat('dd-MM-yyyy', "id_ID").format(
                        DateTime.parse(item.tanggalSerahTerima.toString()))
                    : "",
                footerRightText: item.terlaksana == 0 ? "Proses" : "Terlaksana",
                leading: const CircleAvatar(
                  child: Icon(Icons.article_outlined),
                ),
                titleText: item.purchaseOrder ?? "-",
                subTitleText: item.penyediaJasa?.namaPerusahaan ?? "-",
                trailing: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      if (BastUdaraController.to.isShowTerlaksana(item))
                        const PopupMenuItem(
                          value: "terlaksana",
                          child: Text("Terlaksana"),
                        ),
                      if (BastUdaraController.to.isShowSpu(item))
                        const PopupMenuItem(
                          value: "spu",
                          child: Text("SPU"),
                        ),
                      if (BastUdaraController.to.isShowExportBastUdara(item) ||
                          BastUdaraController.to.isShowExportSpu(item))
                        const PopupMenuItem(
                          value: "export",
                          child: Text("Export"),
                        ),
                      const PopupMenuItem(
                        value: "detail",
                        child: Text("Detail"),
                      ),
                      if (BastUdaraController.to.isShowEdit(item))
                        const PopupMenuItem(
                          value: "ubah",
                          child: Text("Ubah"),
                        ),
                      if (BastUdaraController.to.isShowDelete(item))
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
                    if (value == 'spu') {
                      actionSpu(item);
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

void actionTerlaksana(BastUdara item) {
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
            await BastUdaraController.to.terlaksana(item);
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

void actionSpu(BastUdara item) {
  Get.back();
  Get.toNamed(Routes.spu, arguments: item);
}

void actionExport(context, BastUdara item) {
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
        if (BastUdaraController.to.isShowExportBastUdara(item))
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
                      "${BaseClient.apiUrl}/api/pdf/bast-udara/${item.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/bast-udara/${item.id}?download=true"
                },
              );
            },
          ),
        if (BastUdaraController.to.isShowExportSpu(item))
          ListTile(
            title: const Text("Surat Pengantar Udara"),
            onTap: () {
              Get.back();
              Get.back();
              Get.toNamed(
                Routes.pdf,
                arguments: {
                  "title": "Surat Pengantar Udara",
                  "stream_url":
                      "${BaseClient.apiUrl}/api/pdf/spu/${item.spu?.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/spu/${item.spu?.id}?download=true"
                },
              );
            },
          ),
      ],
    ),
  );
}

void actionDetail(BastUdara item) {
  Get.back();
  Get.toNamed(Routes.detailBastUdara, arguments: item);
}

void actionUbah(BastUdara item) {
  Get.back();
  Get.toNamed(Routes.editBastUdara, arguments: item);
}

void actionHapus(BastUdara item) {
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
            await BastUdaraController.to.destroy(item);
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
