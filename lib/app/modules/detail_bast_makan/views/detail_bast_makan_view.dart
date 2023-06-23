import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/bast_makan.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/base_client.dart';
import 'package:kepulangan/app/widgets/list_detail_widget.dart';
import 'package:kepulangan/app/widgets/no_data_found_widget.dart';
import 'package:kepulangan/app/widgets/simple_list_widget.dart';
import 'package:photo_view/photo_view.dart';

import '../controllers/detail_bast_makan_controller.dart';

class DetailBastMakanView extends GetView<DetailBastMakanController> {
  const DetailBastMakanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Fasilitas Makan'),
        actions: const [
          PopupMenuAppBar(),
        ],
        bottom: TabBar(
          controller: controller.tabController,
          tabs: const [
            Tab(text: "Penyedia Jasa"),
            Tab(text: "Data PMI"),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: const [
          DataPenyediaJasa(),
          DataPmi(),
        ],
      ),
    );
  }
}

class PopupMenuAppBar extends GetView<DetailBastMakanController> {
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
          if (controller.isShowExport())
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

class Uncompleted extends GetView<DetailBastMakanController> {
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
                    actionUbah();
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

class DataPenyediaJasa extends GetView<DetailBastMakanController> {
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
            if (controller.isCompleteBastMakan() == false ||
                controller.isCompleteMakan() == false)
              const Uncompleted(),
            Card(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListDetailWidget(
                      title: "Purchase Order",
                      subtitle: controller.bastMakan.value.purchaseOrder ?? "-",
                    ),
                    const Divider(),
                    ListDetailWidget(
                      title: "Penyedia Jasa",
                      subtitle: controller
                              .bastMakan.value.penyediaJasa?.namaPerusahaan ??
                          "-",
                    ),
                    const Divider(),
                    ListDetailWidget(
                      title: "Alamat Serah Terima",
                      subtitle:
                          controller.bastMakan.value.alamat?.lokasi ?? "-",
                    ),
                    const Divider(),
                    ListDetailWidget(
                      title: "Durasi Pengerjaan",
                      subtitle: controller.bastMakan.value.durasiPengerjaan !=
                              null
                          ? "${controller.bastMakan.value.durasiPengerjaan.toString()} hari pengerjaan"
                          : "-",
                    ),
                    const Divider(),
                    ListDetailWidget(
                      title: "Waktu Serah Terima",
                      subtitle:
                          controller.bastMakan.value.waktuSerahTerima ?? "-",
                    ),
                    const Divider(),
                    ListDetailWidget(
                      title: "Tanggal Serah Terima",
                      subtitle:
                          controller.bastMakan.value.tanggalSerahTerima != null
                              ? DateFormat('dd MMMM yyyy', "id_ID").format(
                                  DateTime.parse(controller
                                      .bastMakan.value.tanggalSerahTerima
                                      .toString()))
                              : "-",
                    ),
                    const Divider(),
                    ListDetailWidget(
                      title: "Status",
                      subtitle: controller.bastMakan.value.terlaksana == 0
                          ? "Proses"
                          : "Terlaksana",
                    ),
                    const Divider(),
                    ListDetailWidget(
                      imageUrl:
                          controller.bastMakan.value.fotoPenyediaJasa ?? "",
                      title: "Foto Penyedia Jasa",
                      onTapListTile: () {
                        showImage("Foto Penyedia Jasa",
                            controller.bastMakan.value.fotoPenyediaJasa);
                      },
                    ),
                    const Divider(),
                    ListDetailWidget(
                      imageUrl:
                          controller.bastMakan.value.fotoSerahTerima ?? "",
                      title: "Foto Serah Terima",
                      onTapListTile: () {
                        showImage("Foto Serah Terima",
                            controller.bastMakan.value.fotoSerahTerima);
                      },
                    ),
                    const Divider(),
                    ListDetailWidget(
                      imageUrl: controller.bastMakan.value.fotoInvoice ?? "",
                      title: "Foto Invoice",
                      onTapListTile: () {
                        showImage("Foto Invoice",
                            controller.bastMakan.value.fotoInvoice);
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

class DataPmi extends GetView<DetailBastMakanController> {
  const DataPmi({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return controller.bastMakan.value.makan!.isNotEmpty
            ? ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  if (controller.isCompleteBastMakan() == false ||
                      controller.isCompleteMakan() == false)
                    const Uncompleted(),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.bastMakan.value.makan?.length,
                    itemBuilder: (context, index) {
                      final item = controller.bastMakan.value.makan?[index];
                      return SimpleListWidget(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: item?.imigran?.nama ?? "",
                        subtitle: item?.imigran?.paspor ?? "",
                        onTap: () {
                          showDetailImigran(item?.imigran);
                        },
                      );
                    },
                  ),
                ],
              )
            : const NoDataFoundWidget(text: "Data tidak ditemukan");
      },
    );
  }
}

void actionTerlaksana() {
  Get.dialog(
    AlertDialog(
      title: const Text('Terlaksana'),
      content: Text(
          'Anda yakin ingin mengubah status "${DetailBastMakanController.to.bastMakan.value.purchaseOrder ?? ""}" menjadi terlaksana?'),
      actions: [
        TextButton(
          child: const Text('Ya'),
          onPressed: () async {
            Get.back();
            await DetailBastMakanController.to.terlaksana();
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
        ListTile(
          title: const Text("Berita Acara Serah Terima Makan"),
          onTap: () {
            Get.back();
            Get.toNamed(
              Routes.pdf,
              arguments: {
                "title": "Berita Acara Serah Terima Makan",
                "stream_url":
                    "${BaseClient.apiUrl}/api/pdf/bast-makan/${DetailBastMakanController.to.bastMakan.value.id}?download=false",
                "download_url":
                    "${BaseClient.apiUrl}/api/pdf/bast-makan/${DetailBastMakanController.to.bastMakan.value.id}?download=true"
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
  result = await Get.toNamed(Routes.editBastMakan,
      arguments: DetailBastMakanController.to.bastMakan.value);
  if (result != null) {
    DetailBastMakanController.to.bastMakan.value = result as BastMakan;
  } else {
    DetailBastMakanController.to.bastMakan.value =
        DetailBastMakanController.to.bastMakan.value;
  }
}

void actionHapus() {
  Get.dialog(
    AlertDialog(
      title: const Text('Hapus'),
      content: Text(
          'Anda yakin ingin menghapus "${DetailBastMakanController.to.bastMakan.value.purchaseOrder ?? ""}"?'),
      actions: [
        TextButton(
          child: const Text('Ya'),
          onPressed: () async {
            Get.back();
            await DetailBastMakanController.to.destroy();
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
