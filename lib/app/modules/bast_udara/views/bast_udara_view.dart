import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/bast_udara.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/base_client.dart';
import 'package:kepulangan/app/widgets/complex_list_widget.dart';
import 'package:kepulangan/app/widgets/error_exception_widget.dart';
import 'package:kepulangan/app/widgets/no_data_found_widget.dart';

import '../controllers/bast_udara_controller.dart';

class BastUdaraView extends GetView<BastUdaraController> {
  const BastUdaraView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshData();
        },
        child: PagedListView<int, BastUdara>(
          padding: const EdgeInsets.all(10),
          pagingController: controller.pagingController,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, item, index) {
              return ComplexListWidget(
                onTap: () {
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
                      if (controller.isShowTerlaksana(item))
                        const PopupMenuItem(
                          value: "terlaksana",
                          child: Text("Terlaksana"),
                        ),
                      if (controller.isShowSpu(item))
                        const PopupMenuItem(
                          value: "spu",
                          child: Text("SPU"),
                        ),
                      if (controller.isShowExportBastUdara(item) ||
                          controller.isShowExportSpu(item))
                        const PopupMenuItem(
                          value: "export",
                          child: Text("Export"),
                        ),
                      const PopupMenuItem(
                        value: "detail",
                        child: Text("Detail"),
                      ),
                      if (controller.isShowEdit(item))
                        const PopupMenuItem(
                          value: "ubah",
                          child: Text("Ubah"),
                        ),
                      if (controller.isShowDelete(item))
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
            noItemsFoundIndicatorBuilder: (context) {
              return NoDataFoundWidget(
                text: "Data tidak ditemukan",
                onPressed: () {
                  controller.pagingController.refresh();
                },
              );
            },
            firstPageErrorIndicatorBuilder: (context) {
              return ErrorExceptionWidget(
                text: controller.pagingController.error,
                onPressed: () {
                  controller.pagingController.refresh();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

void actionTerlaksana(BastUdara item) {
  final BastUdaraController controller = Get.find();
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
            await controller.terlaksana(item);
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
  Get.toNamed(Routes.detailBastUdara, arguments: item);
}

void actionUbah(BastUdara item) {
  Get.toNamed(Routes.editBastUdara, arguments: item);
}

void actionHapus(BastUdara item) {
  final BastUdaraController controller = Get.find();
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
