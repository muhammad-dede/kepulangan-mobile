import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/base_client.dart';
import 'package:kepulangan/app/widgets/complex_list_widget.dart';
import 'package:kepulangan/app/widgets/error_exception_widget.dart';
import 'package:kepulangan/app/widgets/no_data_found_widget.dart';

import '../controllers/imigran_controller.dart';
import 'search_imigran_page.dart';

class ImigranView extends GetView<ImigranController> {
  const ImigranView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelayanan'),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.laporan);
            },
            icon: const Icon(Icons.inventory_outlined),
          ),
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchImigranPage(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: const Column(
        children: [
          MenuArea(),
          Expanded(
            child: ListData(),
          ),
        ],
      ),
    );
  }
}

class MenuArea extends GetView<ImigranController> {
  const MenuArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: controller.listArea.map((item) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              child: ChoiceChip(
                label: Text(item.nama ?? ""),
                selected: controller.idArea.value == item.id ? true : false,
                onSelected: (value) {
                  controller.idArea.value = item.id!;
                  controller.refreshData();
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
// class MenuArea extends GetView<ImigranController> {
//   const MenuArea({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.all(10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 3),
//               child: ChoiceChip(
//                 label: const Text('Semua'),
//                 selected: controller.idArea.value == 0 ? true : false,
//                 onSelected: (value) {
//                   controller.idArea.value = 0;
//                   controller.refreshData();
//                 },
//               ),
//             ),
//             for (var area in controller.listArea)
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 3),
//                 child: ChoiceChip(
//                   label: Text(area.nama ?? ""),
//                   selected: controller.idArea.value == area.id ? true : false,
//                   onSelected: (value) {
//                     controller.idArea.value = area.id!;
//                     controller.refreshData();
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ListData extends GetView<ImigranController> {
  const ListData({super.key});
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.refreshData();
      },
      child: PagedListView<int, Imigran>(
        padding: const EdgeInsets.all(10),
        pagingController: controller.pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) {
            return ComplexListWidget(
              onTap: () {
                Get.toNamed(Routes.detailImigran, arguments: item);
              },
              headerLeftText: item.area?.nama ?? "",
              headerRightText: item.layanan?.nama ?? "",
              footerLeftText: item.tanggalKedatangan != null
                  ? DateFormat('dd-MM-yyyy', "id_ID")
                      .format(DateTime.parse(item.tanggalKedatangan.toString()))
                  : "",
              footerRightText: item.terlaksana == 1 ? "Terlaksana" : "Proses",
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              titleText: item.nama ?? "",
              subTitleText:
                  "${item.paspor ?? ""}${item.pmi?.group != null ? " - Group ${item.pmi?.group?.nama ?? ""}" : ""}",
              trailing: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: "export",
                      child: Text("Export"),
                    ),
                    if (controller.isCanAntarArea(item))
                      PopupMenuItem(
                        value: "antar_area",
                        child: Text(
                          "Antar ke ${item.area?.antarArea?.toArea?.nama ?? ""}",
                        ),
                      ),
                    if (controller.isCanKepulangan(item))
                      const PopupMenuItem(
                        value: "kepulangan",
                        child: Text("Kepulangan"),
                      ),
                    if (controller.isCanEditKepulangan(item))
                      const PopupMenuItem(
                        value: "ubah_kepulangan",
                        child: Text("Ubah Kepulangan"),
                      ),
                    if (controller.isCanTerlaksana(item))
                      const PopupMenuItem(
                        value: "terlaksana",
                        child: Text("Terlaksana"),
                      ),
                    const PopupMenuItem(
                      value: "detail",
                      child: Text("Detail"),
                    ),
                    if (controller.isCanEdit(item))
                      const PopupMenuItem(
                        value: "ubah",
                        child: Text("Ubah"),
                      ),
                    if (controller.isCanDelete(item))
                      const PopupMenuItem(
                        value: "hapus",
                        child: Text("Hapus"),
                      ),
                  ];
                },
                onSelected: (value) {
                  if (value == 'export') {
                    actionExport(context, item);
                  }
                  if (value == 'antar_area') {
                    actionAntarArea(item);
                  }
                  if (value == 'kepulangan') {
                    actionKepulangan(context, item);
                  }
                  if (value == 'ubah_kepulangan') {
                    actionUbahKepulangan(item);
                  }
                  if (value == 'terlaksana') {
                    actionTerlaksana(item);
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
    );
  }
}

void actionExport(context, Imigran imigran) {
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
          title: const Text("Biodata"),
          onTap: () {
            Get.back();
            Get.toNamed(
              Routes.pdf,
              arguments: {
                "title": "Biodata",
                "stream_url":
                    "${BaseClient.apiUrl}/api/pdf/imigran/${imigran.id}?download=false",
                "download_url":
                    "${BaseClient.apiUrl}/api/pdf/imigran/${imigran.id}?download=true"
              },
            );
          },
        ),
        if (ImigranController.to.isDarat(imigran))
          ListTile(
            title: const Text("Berita Acara Serah Terima PMI"),
            onTap: () {
              Get.back();
              Get.toNamed(
                Routes.pdf,
                arguments: {
                  "title": "Berita Acara Serah Terima PMI",
                  "stream_url":
                      "${BaseClient.apiUrl}/api/pdf/bast-darat/${imigran.darat?.bastDarat?.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/bast-darat/${imigran.darat?.bastDarat?.id}?download=true"
                },
              );
            },
          ),
        if (ImigranController.to.isUdara(imigran))
          ListTile(
            title: const Text("Berita Acara Serah Terima PMI"),
            onTap: () {
              Get.back();
              Get.toNamed(
                Routes.pdf,
                arguments: {
                  "title": "Berita Acara Serah Terima PMI",
                  "stream_url":
                      "${BaseClient.apiUrl}/api/pdf/bast-udara/${imigran.udara?.bastUdara?.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/bast-udara/${imigran.udara?.bastUdara?.id}?download=true"
                },
              );
            },
          ),
        if (ImigranController.to.isSpu(imigran))
          ListTile(
            title: const Text("Surat Perintah Udara"),
            onTap: () {
              Get.back();
              Get.toNamed(
                Routes.pdf,
                arguments: {
                  "title": "Surat Perintah Udara",
                  "stream_url":
                      "${BaseClient.apiUrl}/api/pdf/spu/${imigran.udara?.bastUdara?.spu?.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/spu/${imigran.udara?.bastUdara?.spu?.id}?download=true"
                },
              );
            },
          ),
        if (ImigranController.to.isRujukRsPolri(imigran))
          ListTile(
            title: const Text("Berita Acara Serah Terima PMI Sakit"),
            onTap: () {
              Get.back();
              Get.toNamed(
                Routes.pdf,
                arguments: {
                  "title": "Berita Acara Serah Terima PMI Sakit",
                  "stream_url":
                      "${BaseClient.apiUrl}/api/pdf/rujuk-rs-polri/${imigran.rujukRsPolri?.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/rujuk-rs-polri/${imigran.rujukRsPolri?.id}?download=true"
                },
              );
            },
          ),
        if (ImigranController.to.isPulangMandiri(imigran))
          ListTile(
            title: const Text("Surat Permohonan Izin Pulang Mandiri"),
            onTap: () {
              Get.back();
              Get.toNamed(
                Routes.pdf,
                arguments: {
                  "title": "Surat Permohonan Izin Pulang Mandiri",
                  "stream_url":
                      "${BaseClient.apiUrl}/api/pdf/pulang-mandiri/${imigran.pulangMandiri?.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/pulang-mandiri/${imigran.pulangMandiri?.id}?download=true"
                },
              );
            },
          ),
        if (ImigranController.to.isJemputKeluarga(imigran))
          ListTile(
            title: const Text("Surat Pernyataan Penjemputan"),
            onTap: () {
              Get.back();
              Get.toNamed(
                Routes.pdf,
                arguments: {
                  "title": "Surat Pernyataan Penjemputan",
                  "stream_url":
                      "${BaseClient.apiUrl}/api/pdf/jemput-keluarga/${imigran.jemputKeluarga?.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/jemput-keluarga/${imigran.jemputKeluarga?.id}?download=true"
                },
              );
            },
          ),
        if (ImigranController.to.isJemputPihakLain(imigran))
          ListTile(
            title: const Text("Berita Acara Serah Terima PMI"),
            onTap: () {
              Get.back();
              Get.toNamed(
                Routes.pdf,
                arguments: {
                  "title": "Berita Acara Serah Terima PMI",
                  "stream_url":
                      "${BaseClient.apiUrl}/api/pdf/bast-pihak-lain/${imigran.jemputPihakLain?.bastPihakLain?.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/bast-pihak-lain/${imigran.jemputPihakLain?.bastPihakLain?.id}?download=true"
                },
              );
            },
          ),
      ],
    ),
  );
}

void actionAntarArea(Imigran imigran) {
  final ImigranController controller = Get.find();
  Get.dialog(
    AlertDialog(
      title: Text('Antar ke ${imigran.area?.antarArea?.toArea?.nama ?? ""}'),
      content: Text(
          'Anda yakin ingin mengantar ${imigran.nama ?? ""} ke ${imigran.area?.antarArea?.toArea?.nama ?? ""}"?'),
      actions: [
        TextButton(
          child: const Text('Ya'),
          onPressed: () async {
            Get.back();
            controller.antarArea(imigran);
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

void actionKepulangan(context, Imigran imigran) {
  Get.bottomSheet(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(10),
      ),
    ),
    Column(
      children: [
        ListTile(
          title: const Text(
            'Pilih Kepulangan',
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
        Expanded(
          child: ListView.builder(
            itemCount: imigran.area?.kepulangan?.length,
            itemBuilder: (context, index) {
              final kepulangan = imigran.area?.kepulangan?[index];
              return ListTile(
                title: Text(kepulangan?.nama ?? ""),
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.kepulangan, arguments: [
                    {'imigran': imigran},
                    {'kepulangan': kepulangan},
                  ]);
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}

void actionUbahKepulangan(Imigran imigran) {
  Get.toNamed(Routes.kepulangan, arguments: [
    {'imigran': imigran},
    {'kepulangan': imigran.kepulangan},
  ]);
}

void actionTerlaksana(Imigran imigran) {
  final ImigranController controller = Get.find();
  Get.dialog(
    AlertDialog(
      title: const Text('Terlaksana'),
      content: Text(
          'Anda yakin ingin mengubah status "${imigran.nama ?? ""}" menjadi terlaksana?'),
      actions: [
        TextButton(
          child: const Text('Ya'),
          onPressed: () async {
            Get.back();
            await controller.terlaksana(imigran);
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

void actionDetail(Imigran imigran) {
  Get.toNamed(Routes.detailImigran, arguments: imigran);
}

void actionUbah(Imigran imigran) {
  Get.toNamed(Routes.editImigran, arguments: [
    {'area': imigran.area},
    {'layanan': imigran.layanan},
    {'imigran': imigran},
  ]);
}

void actionHapus(Imigran imigran) {
  final ImigranController controller = Get.find();
  Get.dialog(
    AlertDialog(
      title: const Text('Hapus'),
      content: Text('Anda yakin ingin menghapus "${imigran.nama ?? ""}"?'),
      actions: [
        TextButton(
          child: const Text('Ya'),
          onPressed: () async {
            Get.back();
            await controller.destroy(imigran);
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
