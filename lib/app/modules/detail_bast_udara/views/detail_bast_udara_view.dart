import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/bast_udara.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/base_client.dart';
import 'package:kepulangan/app/widgets/list_detail_widget.dart';
import 'package:kepulangan/app/widgets/no_data_found_widget.dart';
import 'package:photo_view/photo_view.dart';

import '../controllers/detail_bast_udara_controller.dart';

class DetailBastUdaraView extends GetView<DetailBastUdaraController> {
  const DetailBastUdaraView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Fasilitas Udara'),
        actions: const [
          PopupMenuAppBar(),
        ],
        bottom: TabBar(
          controller: controller.tabController,
          tabs: const [
            Tab(text: "Penyedia Jasa"),
            Tab(text: "Data PMI"),
            Tab(text: "SPU"),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: const [
          DataPenyediaJasa(),
          DataPmi(),
          DataSpu(),
        ],
      ),
    );
  }
}

class PopupMenuAppBar extends GetView<DetailBastUdaraController> {
  const PopupMenuAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          if (controller.isShowTerlaksana())
            const PopupMenuItem(
              value: "terlaksana",
              child: Text("Terlaksana"),
            ),
          if (controller.isShowSpu())
            const PopupMenuItem(
              value: "spu",
              child: Text("SPU"),
            ),
          if (controller.isShowExportBastUdara() ||
              controller.isShowExportSpu())
            const PopupMenuItem(
              value: "export",
              child: Text("Export"),
            ),
          if (controller.isShowEdit())
            const PopupMenuItem(
              value: "ubah",
              child: Text("Ubah"),
            ),
          if (controller.isShowDelete())
            const PopupMenuItem(
              value: "hapus",
              child: Text("Hapus"),
            ),
        ];
      },
      onSelected: (value) {
        if (value == 'terlaksana') {
          actionTerlaksana();
        }
        if (value == 'spu') {
          actionSpu();
        }
        if (value == 'export') {
          actionExport(context);
        }
        if (value == 'ubah') {
          actionUbah();
        }
        if (value == 'hapus') {
          actionHapus();
        }
      },
    );
  }
}

class Uncompleted extends GetView<DetailBastUdaraController> {
  const Uncompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 10),
                const Flexible(
                  child: Text(
                    "Lengkapi seluruh data untuk menyelesaikan.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (controller.isShowExportBastUdara() == false) {
                      actionUbah();
                    }
                    if (controller.isShowExportSpu() == false) {
                      actionSpu();
                    }
                  },
                  child: const Text("Lengkapi"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DataPenyediaJasa extends GetView<DetailBastUdaraController> {
  const DataPenyediaJasa({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ListView(
          padding: const EdgeInsets.all(10),
          children: [
            if (controller.isShowExportBastUdara() == false ||
                controller.isShowExportSpu() == false)
              const Uncompleted(),
            Card(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListDetailWidget(
                      title: "Purchase Order",
                      subtitle: controller.bastUdara.value.purchaseOrder ?? "-",
                    ),
                    const Divider(),
                    ListDetailWidget(
                      title: "Nama Penyedia Jasa",
                      subtitle: controller
                              .bastUdara.value.penyediaJasa?.namaPerusahaan ??
                          "-",
                    ),
                    const Divider(),
                    ListDetailWidget(
                      title: "Alamat Penyedia Jasa",
                      subtitle:
                          controller.bastUdara.value.penyediaJasa?.alamat ??
                              "-",
                    ),
                    const Divider(),
                    ListDetailWidget(
                      title: "Email Penyedia Jasa",
                      subtitle:
                          controller.bastUdara.value.penyediaJasa?.email ?? "-",
                    ),
                    const Divider(),
                    ListDetailWidget(
                      title: "No. Telepon Penyedia Jasa",
                      subtitle:
                          controller.bastUdara.value.penyediaJasa?.noTelp ??
                              "-",
                    ),
                    const Divider(),
                    ListDetailWidget(
                      title: "UP",
                      subtitle:
                          controller.bastUdara.value.penyediaJasa?.up ?? "-",
                    ),
                    const Divider(),
                    ListDetailWidget(
                      title: "Lokasi Jemput",
                      subtitle:
                          controller.bastUdara.value.alamat?.lokasi ?? "-",
                    ),
                    const Divider(),
                    ListDetailWidget(
                      title: "Durasi Pengerjaan",
                      subtitle: controller.bastUdara.value.durasiPengerjaan !=
                              null
                          ? "${controller.bastUdara.value.durasiPengerjaan.toString()} hari pengerjaan"
                          : "-",
                    ),
                    const Divider(),
                    ListDetailWidget(
                      title: "Tanggal Serah Terima",
                      subtitle:
                          controller.bastUdara.value.tanggalSerahTerima != null
                              ? DateFormat('dd MMMM yyyy', "id_ID").format(
                                  DateTime.parse(controller
                                      .bastUdara.value.tanggalSerahTerima
                                      .toString()))
                              : "-",
                    ),
                    const Divider(),
                    ListDetailWidget(
                      title: "Status",
                      subtitle: controller.bastUdara.value.terlaksana == 0
                          ? "Proses"
                          : "Terlaksana",
                    ),
                    const Divider(),
                    ListDetailWidget(
                      imageUrl:
                          controller.bastUdara.value.fotoPenyediaJasa ?? "",
                      title: "Foto Penyedia Jasa",
                      onTapListTile: () {
                        showImage("Foto Penyedia Jasa",
                            controller.bastUdara.value.fotoPenyediaJasa);
                      },
                    ),
                    const Divider(),
                    ListDetailWidget(
                      imageUrl:
                          controller.bastUdara.value.fotoSerahTerima ?? "",
                      title: "Foto Serah Terima",
                      onTapListTile: () {
                        showImage("Foto Serah Terima",
                            controller.bastUdara.value.fotoSerahTerima);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DataPmi extends GetView<DetailBastUdaraController> {
  const DataPmi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return controller.bastUdara.value.udara!.isNotEmpty
            ? ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  if (controller.isShowExportBastUdara() == false ||
                      controller.isShowExportSpu() == false)
                    const Uncompleted(),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.bastUdara.value.udara?.length,
                    itemBuilder: (context, index) {
                      final item = controller.bastUdara.value.udara?[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: ListDetailWidget(
                            imageUrl: item?.fotoBoardingPass ?? "",
                            title: item?.imigran?.nama ?? "-",
                            subtitle: item?.imigran?.paspor ?? "-",
                            onTapImage: () {
                              showImage("Foto Bast", item?.fotoBoardingPass);
                            },
                            onTapListTile: () {
                              showDetailImigran(item?.imigran);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            : const NoDataFoundWidget(text: "Belum Ada Data");
      },
    );
  }
}

class DataSpu extends GetView<DetailBastUdaraController> {
  const DataSpu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return controller.bastUdara.value.spu != null
            ? ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  if (controller.isShowExportBastUdara() == false ||
                      controller.isShowExportSpu() == false)
                    const Uncompleted(),
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListDetailWidget(
                            title: "No Surat",
                            subtitle:
                                controller.bastUdara.value.spu?.noSurat ?? "-",
                          ),
                          const Divider(),
                          ListDetailWidget(
                            title: "Tanggal Surat",
                            subtitle:
                                controller.bastUdara.value.spu?.tanggalSurat !=
                                        null
                                    ? DateFormat('dd MMMM yyyy', "id_ID")
                                        .format(DateTime.parse(controller
                                            .bastUdara.value.spu!.tanggalSurat
                                            .toString()))
                                    : "-",
                          ),
                          const Divider(),
                          ListDetailWidget(
                            title: "Provinsi",
                            subtitle: controller
                                    .bastUdara.value.spu?.provinsi?.nama ??
                                "-",
                          ),
                          const Divider(),
                          ListDetailWidget(
                            title: "No. Pesawat",
                            subtitle:
                                controller.bastUdara.value.spu?.noPesawat ??
                                    "-",
                          ),
                          const Divider(),
                          ListDetailWidget(
                            title: "Jam Pesawat",
                            subtitle:
                                controller.bastUdara.value.spu?.jamPesawat ??
                                    "-",
                          ),
                          const Divider(),
                          ListDetailWidget(
                            title: "Tanggal Pesawat",
                            subtitle: controller
                                        .bastUdara.value.spu?.tanggalPesawat !=
                                    null
                                ? DateFormat('dd MMMM yyyy', "id_ID").format(
                                    DateTime.parse(controller
                                        .bastUdara.value.spu!.tanggalPesawat
                                        .toString()))
                                : "-",
                          ),
                          if (controller
                              .bastUdara.value.spu!.spuTiket!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                const ListDetailWidget(
                                  title: "Foto Tiket",
                                ),
                                GridView.builder(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20,
                                    childAspectRatio: 1 / 1,
                                  ),
                                  itemCount: controller
                                      .bastUdara.value.spu!.spuTiket?.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final item = controller
                                        .bastUdara.value.spu?.spuTiket?[index];
                                    return GestureDetector(
                                      onTap: () {
                                        showImage(
                                            "Foto Tiket", item?.fotoTiket);
                                      },
                                      child: FotoTiket(
                                        imageUrl: item?.fotoTiket,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : const NoDataFoundWidget(text: "Belum Ada Data");
      },
    );
  }
}

class FotoTiket extends GetView<DetailBastUdaraController> {
  const FotoTiket({
    super.key,
    this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailBastUdaraController>(
      builder: (controller) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            child: CachedNetworkImage(
              key: UniqueKey(),
              fit: BoxFit.cover,
              imageUrl: imageUrl ?? "",
              placeholder: (context, url) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              errorWidget: (context, url, error) {
                return const Icon(Icons.image);
              },
              cacheManager: CacheManager(
                Config(
                  "foto_tiket",
                  stalePeriod: const Duration(days: 3),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

void actionTerlaksana() {
  Get.dialog(
    AlertDialog(
      title: const Text('Terlaksana'),
      content: Text(
          'Anda yakin ingin mengubah status "${DetailBastUdaraController.to.bastUdara.value.purchaseOrder ?? ""}" menjadi terlaksana?'),
      actions: [
        TextButton(
          child: const Text('Ya'),
          onPressed: () async {
            Get.back();
            await DetailBastUdaraController.to.terlaksana();
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

void actionSpu() async {
  dynamic result = await Get.toNamed(Routes.spu,
      arguments: DetailBastUdaraController.to.bastUdara.value);
  if (result != null) {
    DetailBastUdaraController.to.bastUdara.value = result as BastUdara;
  } else {
    DetailBastUdaraController.to.bastUdara.value =
        DetailBastUdaraController.to.bastUdara.value;
  }
}

void actionExport(context) {
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
        if (DetailBastUdaraController.to.isShowExportBastUdara())
          ListTile(
            title: const Text("Berita Acara Serah Terima PMI"),
            onTap: () {
              Get.back();
              Get.toNamed(
                Routes.pdf,
                arguments: {
                  "title": "Berita Acara Serah Terima PMI",
                  "stream_url":
                      "${BaseClient.apiUrl}/api/pdf/bast-udara/${DetailBastUdaraController.to.bastUdara.value.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/bast-udara/${DetailBastUdaraController.to.bastUdara.value.id}?download=true"
                },
              );
            },
          ),
        if (DetailBastUdaraController.to.isShowExportSpu())
          ListTile(
            title: const Text("Surat Pengantar Udara"),
            onTap: () {
              Get.back();
              Get.toNamed(
                Routes.pdf,
                arguments: {
                  "title": "Surat Pengantar Udara",
                  "stream_url":
                      "${BaseClient.apiUrl}/api/pdf/spu/${DetailBastUdaraController.to.bastUdara.value.spu?.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/spu/${DetailBastUdaraController.to.bastUdara.value.spu?.id}?download=true"
                },
              );
            },
          ),
      ],
    ),
  );
}

void actionUbah() async {
  dynamic result;
  result = await Get.toNamed(Routes.editBastUdara,
      arguments: DetailBastUdaraController.to.bastUdara.value);
  if (result != null) {
    DetailBastUdaraController.to.bastUdara.value = result as BastUdara;
  } else {
    DetailBastUdaraController.to.bastUdara.value =
        DetailBastUdaraController.to.bastUdara.value;
  }
}

void actionHapus() {
  Get.dialog(
    AlertDialog(
      title: const Text('Hapus'),
      content: Text(
          'Anda yakin ingin menghapus "${DetailBastUdaraController.to.bastUdara.value.purchaseOrder ?? ""}"?'),
      actions: [
        TextButton(
          child: const Text('Ya'),
          onPressed: () async {
            Get.back();
            await DetailBastUdaraController.to.destroy();
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

void showImage(String? title, String? imageUrl) {
  Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: false,
    enableDrag: false,
    StatefulBuilder(
      builder: (context, index) {
        return Scaffold(
          appBar: AppBar(
            title: Text("$title"),
          ),
          body: CachedNetworkImage(
            key: UniqueKey(),
            imageUrl: imageUrl ?? "",
            imageBuilder: (context, imageProvider) => PhotoView(
              imageProvider: imageProvider,
            ),
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.image, size: 100),
            ),
          ),
        );
      },
    ),
  );
}

void showDetailImigran(Imigran? imigran) {
  Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: false,
    enableDrag: false,
    isDismissible: false,
    Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Detail PMI"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Card(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListDetailWidget(
                    title: "Brafaks",
                    subtitle: imigran?.brafaks ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Paspor",
                    subtitle: imigran?.paspor ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Nama",
                    subtitle: imigran?.nama ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Jenis Kelamin",
                    subtitle: imigran?.jenisKelamin?.nama ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Negara",
                    subtitle: imigran?.negara?.nama ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Sub Kawasan",
                    subtitle: imigran?.subKawasan?.nama ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Kawasan",
                    subtitle: imigran?.kawasan?.nama ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Alamat",
                    subtitle: imigran?.alamat ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Provinsi",
                    subtitle: imigran?.provinsi?.nama ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Kabupaten/Kota",
                    subtitle: imigran?.kabKota?.nama ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "No. Telepon",
                    subtitle: imigran?.noTelp ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Jabatan",
                    subtitle: imigran?.jabatan?.nama ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Tanggal Kedatangan",
                    subtitle: imigran?.tanggalKedatangan != null
                        ? DateFormat('dd MMMM yyyy', "id_ID")
                            .format(DateTime.parse(
                                imigran!.tanggalKedatangan.toString()))
                            .toString()
                        : "-",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
