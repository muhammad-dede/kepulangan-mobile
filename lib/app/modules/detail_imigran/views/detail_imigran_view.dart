import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/widgets/list_detail_widget.dart';
import 'package:kepulangan/app/widgets/no_data_found_widget.dart';
import 'package:kepulangan/app/services/base_client.dart';
import 'package:photo_view/photo_view.dart';

import '../controllers/detail_imigran_controller.dart';

class DetailImigranView extends GetView<DetailImigranController> {
  const DetailImigranView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(controller.imigran.value.area?.nama ?? ""),
          actions: const [
            PopupMenuAppBar(),
          ],
        ),
        body: Column(
          children: [
            const Header(),
            TabBar(
              controller: controller.tabController,
              tabs: const [
                Tab(text: "Biodata"),
                Tab(text: "Kepulangan"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: const [
                  Biodata(),
                  Kepulangan(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PopupMenuAppBar extends GetView<DetailImigranController> {
  const PopupMenuAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: "export",
            child: Text("Export"),
          ),
          if (controller.isCarAntarArea())
            PopupMenuItem(
              value: "antar_area",
              child: Text(
                "Antar ke ${controller.imigran.value.area?.antarArea?.toArea?.nama ?? ""}",
              ),
            ),
          if (controller.isCanKepulangan())
            const PopupMenuItem(
              value: "kepulangan",
              child: Text("Kepulangan"),
            ),
          if (controller.isCanEditKepulangan())
            const PopupMenuItem(
              value: "ubah_kepulangan",
              child: Text("Ubah Kepulangan"),
            ),
          if (controller.isCanTerlaksana())
            const PopupMenuItem(
              value: "terlaksana",
              child: Text("Terlaksana"),
            ),
          if (controller.isCanEdit())
            const PopupMenuItem(
              value: "ubah",
              child: Text("Ubah"),
            ),
          if (controller.isCanDelete())
            const PopupMenuItem(
              value: "hapus",
              child: Text("Hapus"),
            ),
        ];
      },
      onSelected: (value) {
        if (value == 'export') {
          actionExport(context);
        }
        if (value == 'antar_area') {
          actionAntarArea();
        }
        if (value == 'kepulangan') {
          actionKepulangan(context);
        }
        if (value == 'ubah_kepulangan') {
          actionUbahKepulangan();
        }
        if (value == 'terlaksana') {
          actionTerlaksana();
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

class Header extends GetView<DetailImigranController> {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        child: Card(
          child: ListTile(
            title: const Text('Layanan'),
            subtitle: Text(
              controller.imigran.value.layanan?.nama ?? "",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Text(controller.imigran.value.terlaksana == 1
                ? "Terlaksana"
                : "Proses"),
          ),
        ),
      ),
    );
  }
}

class Biodata extends GetView<DetailImigranController> {
  const Biodata({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
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
                    subtitle: controller.imigran.value.brafaks ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Paspor",
                    subtitle: controller.imigran.value.paspor ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Nama",
                    subtitle: controller.imigran.value.nama ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Jenis Kelamin",
                    subtitle:
                        controller.imigran.value.jenisKelamin?.nama ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Negara",
                    subtitle: controller.imigran.value.negara?.nama ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Sub Kawasan",
                    subtitle: controller.imigran.value.subKawasan?.nama ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Kawasan",
                    subtitle: controller.imigran.value.kawasan?.nama ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Alamat",
                    subtitle: controller.imigran.value.alamat ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Provinsi",
                    subtitle: controller.imigran.value.provinsi?.nama ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Kabupaten/Kota",
                    subtitle: controller.imigran.value.kabKota?.nama ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "No. Telepon",
                    subtitle: controller.imigran.value.noTelp ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Jabatan",
                    subtitle: controller.imigran.value.jabatan?.nama ?? "-",
                  ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Tanggal Kedatangan",
                    subtitle: controller.imigran.value.tanggalKedatangan != null
                        ? DateFormat('dd MMMM yyyy', "id_ID")
                            .format(DateTime.parse(controller
                                .imigran.value.tanggalKedatangan
                                .toString()))
                            .toString()
                        : "-",
                  ),
                  if (controller.imigran.value.pmi?.group != null)
                    Column(
                      children: [
                        const Divider(),
                        ListDetailWidget(
                          title: "Group",
                          subtitle:
                              controller.imigran.value.pmi?.group?.nama ?? "-",
                        ),
                      ],
                    ),
                  if (controller.imigran.value.pmi?.masalah != null)
                    Column(
                      children: [
                        const Divider(),
                        ListDetailWidget(
                          title: "Masalah",
                          subtitle:
                              controller.imigran.value.pmi?.masalah?.nama ??
                                  "-",
                        ),
                      ],
                    ),
                  const Divider(),
                  ListDetailWidget(
                    title: "Petugas",
                    subtitle: controller.imigran.value.user?.nama ?? "-",
                  ),
                  if (controller.imigran.value.pmi?.fotoPmi != null)
                    Column(
                      children: [
                        const Divider(),
                        ListDetailWidget(
                          imageUrl: controller.imigran.value.pmi?.fotoPmi ?? "",
                          title: "Foto PMI",
                          onTapListTile: () {
                            showImage("Foto PMI",
                                controller.imigran.value.pmi?.fotoPmi);
                          },
                        ),
                      ],
                    ),
                  if (controller.imigran.value.pmi?.fotoPaspor != null)
                    Column(
                      children: [
                        const Divider(),
                        ListDetailWidget(
                          imageUrl:
                              controller.imigran.value.pmi?.fotoPaspor ?? "",
                          title: "Foto Paspor",
                          onTapListTile: () {
                            showImage("Foto Paspor",
                                controller.imigran.value.pmi?.fotoPaspor);
                          },
                        ),
                      ],
                    ),
                  if (controller.imigran.value.jenazah?.fotoJenazah != null)
                    Column(
                      children: [
                        const Divider(),
                        ListDetailWidget(
                          imageUrl:
                              controller.imigran.value.jenazah?.fotoJenazah ??
                                  "",
                          title: "Foto Jenazah",
                          onTapListTile: () {
                            showImage("Foto Jenazah",
                                controller.imigran.value.jenazah?.fotoJenazah);
                          },
                        ),
                      ],
                    ),
                  if (controller.imigran.value.jenazah?.fotoPaspor != null)
                    Column(
                      children: [
                        const Divider(),
                        ListDetailWidget(
                          imageUrl:
                              controller.imigran.value.jenazah?.fotoPaspor ??
                                  "",
                          title: "Foto Paspor",
                          onTapListTile: () {
                            showImage("Foto Paspor",
                                controller.imigran.value.jenazah?.fotoPaspor);
                          },
                        ),
                      ],
                    ),
                  if (controller.imigran.value.jenazah?.fotoBrafaks != null)
                    Column(
                      children: [
                        const Divider(),
                        ListDetailWidget(
                          imageUrl:
                              controller.imigran.value.jenazah?.fotoBrafaks ??
                                  "",
                          title: "Foto Brafaks",
                          onTapListTile: () {
                            showImage("Foto Brafaks",
                                controller.imigran.value.jenazah?.fotoBrafaks);
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Kepulangan extends GetView<DetailImigranController> {
  const Kepulangan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.imigran.value.kepulangan == null
          ? const NoDataFoundWidget(
              text: "Data tidak ditemukan",
            )
          : ListView(
              padding: const EdgeInsets.all(10),
              children: [
                if (controller.imigran.value.jenazah != null) const Jenazah(),
                if (controller.imigran.value.darat != null) const Darat(),
                if (controller.imigran.value.udara != null) const Udara(),
                if (controller.imigran.value.rujukRsPolri != null)
                  const RujukRsPolri(),
                if (controller.imigran.value.pulangMandiri != null)
                  const PulangMandiri(),
                if (controller.imigran.value.jemputKeluarga != null)
                  const JemputKeluarga(),
                if (controller.imigran.value.jemputPihakLain != null)
                  const JemputPihakLain(),
              ],
            ),
    );
  }
}

class Jenazah extends GetView<DetailImigranController> {
  const Jenazah({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListDetailWidget(
                title: "Cargo",
                subtitle: controller.imigran.value.jenazah?.cargo?.nama ?? "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Kepulangan",
                subtitle: controller.imigran.value.kepulangan?.nama ?? "-",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Darat extends GetView<DetailImigranController> {
  const Darat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListDetailWidget(
                title: "Kepulangan",
                subtitle: controller.imigran.value.kepulangan?.nama ?? "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Nama Penyedia Jasa",
                subtitle: controller.imigran.value.darat?.bastDarat
                        ?.penyediaJasa?.namaPerusahaan ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Alamat Penyedia Jasa",
                subtitle: controller
                        .imigran.value.darat?.bastDarat?.penyediaJasa?.alamat ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Email Penyedia Jasa",
                subtitle: controller
                        .imigran.value.darat?.bastDarat?.penyediaJasa?.email ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "No. Telepon Penyedia Jasa",
                subtitle: controller
                        .imigran.value.darat?.bastDarat?.penyediaJasa?.noTelp ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "UP",
                subtitle: controller
                        .imigran.value.darat?.bastDarat?.penyediaJasa?.up ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Lokasi Jemput",
                subtitle:
                    controller.imigran.value.darat?.bastDarat?.alamat?.lokasi ??
                        "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Durasi Pengerjaan",
                subtitle: controller
                            .imigran.value.darat?.bastDarat?.durasiPengerjaan !=
                        null
                    ? "${controller.imigran.value.darat?.bastDarat?.durasiPengerjaan.toString()} hari pengerjaan"
                    : "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Tanggal Serah Terima",
                subtitle: controller.imigran.value.darat?.bastDarat
                            ?.tanggalSerahTerima !=
                        null
                    ? DateFormat('dd MMMM yyyy', "id_ID").format(DateTime.parse(
                        controller
                            .imigran.value.darat!.bastDarat!.tanggalSerahTerima
                            .toString()))
                    : "-",
              ),
              const Divider(),
              ListDetailWidget(
                imageUrl: controller.imigran.value.darat?.fotoBast ?? "",
                title: "Foto Bast",
                onTapListTile: () {
                  showImage(
                      "Foto Bast", controller.imigran.value.darat?.fotoBast);
                },
              ),
              const Divider(),
              ListDetailWidget(
                imageUrl: controller
                        .imigran.value.darat?.bastDarat?.fotoPenyediaJasa ??
                    "",
                title: "Foto Penyedia Jasa",
                onTapListTile: () {
                  showImage(
                      "Foto Penyedia Jasa",
                      controller
                          .imigran.value.darat?.bastDarat?.fotoPenyediaJasa);
                },
              ),
              const Divider(),
              ListDetailWidget(
                imageUrl: controller
                        .imigran.value.darat?.bastDarat?.fotoSerahTerima ??
                    "",
                title: "Foto Serah Terima",
                onTapListTile: () {
                  showImage(
                      "Foto Serah Terima",
                      controller
                          .imigran.value.darat?.bastDarat?.fotoSerahTerima);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Udara extends GetView<DetailImigranController> {
  const Udara({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListDetailWidget(
                title: "Kepulangan",
                subtitle: controller.imigran.value.kepulangan?.nama ?? "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Nama Penyedia Jasa",
                subtitle: controller.imigran.value.udara?.bastUdara
                        ?.penyediaJasa?.namaPerusahaan ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Alamat Penyedia Jasa",
                subtitle: controller
                        .imigran.value.udara?.bastUdara?.penyediaJasa?.alamat ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Email Penyedia Jasa",
                subtitle: controller
                        .imigran.value.udara?.bastUdara?.penyediaJasa?.email ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "No. Telepon Penyedia Jasa",
                subtitle: controller
                        .imigran.value.udara?.bastUdara?.penyediaJasa?.noTelp ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "UP",
                subtitle: controller
                        .imigran.value.udara?.bastUdara?.penyediaJasa?.up ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Lokasi Jemput",
                subtitle:
                    controller.imigran.value.udara?.bastUdara?.alamat?.lokasi ??
                        "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Durasi Pengerjaan",
                subtitle: controller
                            .imigran.value.udara?.bastUdara?.durasiPengerjaan !=
                        null
                    ? "${controller.imigran.value.udara?.bastUdara?.durasiPengerjaan.toString()} hari pengerjaan"
                    : "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Tanggal Serah Terima",
                subtitle: controller.imigran.value.udara?.bastUdara
                            ?.tanggalSerahTerima !=
                        null
                    ? DateFormat('dd MMMM yyyy', "id_ID").format(DateTime.parse(
                        controller
                            .imigran.value.udara!.bastUdara!.tanggalSerahTerima
                            .toString()))
                    : "-",
              ),
              const Divider(),
              ListDetailWidget(
                imageUrl:
                    controller.imigran.value.udara?.fotoBoardingPass ?? "",
                title: "Foto Boarding Pass",
                onTapListTile: () {
                  showImage("Foto Boarding Pass",
                      controller.imigran.value.udara?.fotoBoardingPass);
                },
              ),
              const Divider(),
              ListDetailWidget(
                imageUrl: controller
                        .imigran.value.udara?.bastUdara?.fotoPenyediaJasa ??
                    "",
                title: "Foto Penyedia Jasa",
                onTapListTile: () {
                  showImage(
                      "Foto Penyedia Jasa",
                      controller
                          .imigran.value.udara?.bastUdara?.fotoPenyediaJasa);
                },
              ),
              const Divider(),
              ListDetailWidget(
                imageUrl: controller
                        .imigran.value.udara?.bastUdara?.fotoSerahTerima ??
                    "",
                title: "Foto Serah Terima",
                onTapListTile: () {
                  showImage(
                      "Foto Serah Terima",
                      controller
                          .imigran.value.udara?.bastUdara?.fotoSerahTerima);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RujukRsPolri extends GetView<DetailImigranController> {
  const RujukRsPolri({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListDetailWidget(
                title: "Kepulangan",
                subtitle: controller.imigran.value.kepulangan?.nama ?? "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Nama Pihak Kedua",
                subtitle:
                    controller.imigran.value.rujukRsPolri?.pihakKedua?.nama ??
                        "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "No. Identitas Pihak Kedua",
                subtitle: controller
                        .imigran.value.rujukRsPolri?.pihakKedua?.noIdentitas ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Jabatan Pihak Kedua",
                subtitle: controller
                        .imigran.value.rujukRsPolri?.pihakKedua?.jabatan ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Alamat Pihak Kedua",
                subtitle:
                    controller.imigran.value.rujukRsPolri?.pihakKedua?.alamat ??
                        "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "No. Telepon Pihak Kedua",
                subtitle:
                    controller.imigran.value.rujukRsPolri?.pihakKedua?.noTelp ??
                        "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Tanggal Serah Terima",
                subtitle:
                    controller.imigran.value.rujukRsPolri?.tanggalSerahTerima !=
                            null
                        ? DateFormat('dd MMMM yyyy', "id_ID")
                            .format(DateTime.parse(controller
                                .imigran.value.rujukRsPolri!.tanggalSerahTerima
                                .toString()))
                            .toString()
                        : "-",
              ),
              const Divider(),
              ListDetailWidget(
                imageUrl:
                    controller.imigran.value.rujukRsPolri?.fotoPihakKedua ?? "",
                title: "Foto Pihak Kedua",
                onTapListTile: () {
                  showImage("Foto Pihak Kedua",
                      controller.imigran.value.rujukRsPolri?.fotoPihakKedua);
                },
              ),
              const Divider(),
              ListDetailWidget(
                imageUrl:
                    controller.imigran.value.rujukRsPolri?.fotoSerahTerima ??
                        "",
                title: "Foto Serah Terima",
                onTapListTile: () {
                  showImage("Foto Serah Terima",
                      controller.imigran.value.rujukRsPolri?.fotoSerahTerima);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PulangMandiri extends GetView<DetailImigranController> {
  const PulangMandiri({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListDetailWidget(
                title: "Kepulangan",
                subtitle: controller.imigran.value.kepulangan?.nama ?? "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Tanggal Serah Terima",
                subtitle: controller
                            .imigran.value.pulangMandiri!.tanggalSerahTerima !=
                        null
                    ? DateFormat('dd MMMM yyyy', "id_ID")
                        .format(DateTime.parse(controller
                            .imigran.value.pulangMandiri!.tanggalSerahTerima
                            .toString()))
                        .toString()
                    : "-",
              ),
              const Divider(),
              ListDetailWidget(
                imageUrl:
                    controller.imigran.value.pulangMandiri?.fotoSerahTerima ??
                        "",
                title: "Foto Serah Terima",
                onTapListTile: () {
                  showImage("Foto Serah Terima",
                      controller.imigran.value.pulangMandiri?.fotoSerahTerima);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JemputKeluarga extends GetView<DetailImigranController> {
  const JemputKeluarga({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListDetailWidget(
                title: "Kepulangan",
                subtitle: controller.imigran.value.kepulangan?.nama ?? "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Nama Penjemput",
                subtitle:
                    controller.imigran.value.jemputKeluarga?.namaPenjemput ??
                        "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Hubungan dengan PMI",
                subtitle: controller
                        .imigran.value.jemputKeluarga?.hubunganDenganPmi ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "No. Telepon Penjemput",
                subtitle:
                    controller.imigran.value.jemputKeluarga?.noTelpPenjemput ??
                        "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Tanggal Serah Terima",
                subtitle: controller
                            .imigran.value.jemputKeluarga?.tanggalSerahTerima !=
                        null
                    ? DateFormat('dd MMMM yyyy', "id_ID")
                        .format(DateTime.parse(controller
                            .imigran.value.jemputKeluarga!.tanggalSerahTerima
                            .toString()))
                        .toString()
                    : "-",
              ),
              const Divider(),
              ListDetailWidget(
                imageUrl:
                    controller.imigran.value.jemputKeluarga?.fotoPenjemput ??
                        "",
                title: "Foto Penjemput",
                onTapListTile: () {
                  showImage("Foto Penjemput",
                      controller.imigran.value.jemputKeluarga?.fotoPenjemput);
                },
              ),
              const Divider(),
              ListDetailWidget(
                imageUrl:
                    controller.imigran.value.jemputKeluarga?.fotoSerahTerima ??
                        "",
                title: "Foto Serah Terima",
                onTapListTile: () {
                  showImage("Foto Serah Terima",
                      controller.imigran.value.jemputKeluarga?.fotoSerahTerima);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JemputPihakLain extends GetView<DetailImigranController> {
  const JemputPihakLain({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListDetailWidget(
                title: "Kepulangan",
                subtitle: controller.imigran.value.kepulangan?.nama ?? "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Nama Pihak Kedua",
                subtitle: controller.imigran.value.jemputPihakLain
                        ?.bastPihakLain?.pihakKedua?.nama ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "No. Identitas Pihak Kedua",
                subtitle: controller.imigran.value.jemputPihakLain
                        ?.bastPihakLain?.pihakKedua?.noIdentitas ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Jabatan Pihak Kedua",
                subtitle: controller.imigran.value.jemputPihakLain
                        ?.bastPihakLain?.pihakKedua?.jabatan ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Instansi Pihak Kedua",
                subtitle: controller.imigran.value.jemputPihakLain
                        ?.bastPihakLain?.pihakKedua?.instansi ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Alamat Pihak Kedua",
                subtitle: controller.imigran.value.jemputPihakLain
                        ?.bastPihakLain?.pihakKedua?.alamat ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "No. Telepon Pihak Kedua",
                subtitle: controller.imigran.value.jemputPihakLain
                        ?.bastPihakLain?.pihakKedua?.noTelp ??
                    "-",
              ),
              const Divider(),
              ListDetailWidget(
                title: "Tanggal Serah Terima",
                subtitle: controller.imigran.value.jemputPihakLain
                            ?.bastPihakLain?.tanggalSerahTerima !=
                        null
                    ? DateFormat('dd MMMM yyyy', "id_ID")
                        .format(DateTime.parse(controller.imigran.value
                            .jemputPihakLain!.bastPihakLain!.tanggalSerahTerima
                            .toString()))
                        .toString()
                    : "-",
              ),
              const Divider(),
              ListDetailWidget(
                imageUrl: controller.imigran.value.jemputPihakLain
                        ?.bastPihakLain?.fotoPihakKedua ??
                    "",
                title: "Foto Pihak Kedua",
                onTapListTile: () {
                  showImage(
                      "Foto Pihak Kedua",
                      controller.imigran.value.jemputPihakLain?.bastPihakLain
                          ?.fotoPihakKedua);
                },
              ),
              const Divider(),
              ListDetailWidget(
                imageUrl: controller.imigran.value.jemputPihakLain
                        ?.bastPihakLain?.fotoSerahTerima ??
                    "",
                title: "Foto Serah Terima",
                onTapListTile: () {
                  showImage(
                      "Foto Serah Terima",
                      controller.imigran.value.jemputPihakLain?.bastPihakLain
                          ?.fotoSerahTerima);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
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
          title: const Text("Biodata"),
          onTap: () {
            Get.back();
            Get.toNamed(
              Routes.pdf,
              arguments: {
                "title": "Biodata",
                "stream_url":
                    "${BaseClient.apiUrl}/api/pdf/imigran/${DetailImigranController.to.imigran.value.id}?download=false",
                "download_url":
                    "${BaseClient.apiUrl}/api/pdf/imigran/${DetailImigranController.to.imigran.value.id}?download=true"
              },
            );
          },
        ),
        if (DetailImigranController.to.isDarat())
          ListTile(
            title: const Text("Berita Acara Serah Terima PMI"),
            onTap: () {
              Get.back();
              Get.toNamed(
                Routes.pdf,
                arguments: {
                  "title": "Berita Acara Serah Terima PMI",
                  "stream_url":
                      "${BaseClient.apiUrl}/api/pdf/bast-darat/${DetailImigranController.to.imigran.value.darat?.bastDarat?.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/bast-darat/${DetailImigranController.to.imigran.value.darat?.bastDarat?.id}?download=true"
                },
              );
            },
          ),
        if (DetailImigranController.to.isUdara())
          ListTile(
            title: const Text("Berita Acara Serah Terima PMI"),
            onTap: () {
              Get.back();
              Get.toNamed(
                Routes.pdf,
                arguments: {
                  "title": "Berita Acara Serah Terima PMI",
                  "stream_url":
                      "${BaseClient.apiUrl}/api/pdf/bast-udara/${DetailImigranController.to.imigran.value.udara?.bastUdara?.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/bast-udara/${DetailImigranController.to.imigran.value.udara?.bastUdara?.id}?download=true"
                },
              );
            },
          ),
        if (DetailImigranController.to.isSpu())
          ListTile(
            title: const Text("Surat Perintah Udara"),
            onTap: () {
              Get.back();
              Get.toNamed(
                Routes.pdf,
                arguments: {
                  "title": "Surat Perintah Udara",
                  "stream_url":
                      "${BaseClient.apiUrl}/api/pdf/spu/${DetailImigranController.to.imigran.value.udara?.bastUdara?.spu?.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/spu/${DetailImigranController.to.imigran.value.udara?.bastUdara?.spu?.id}?download=true"
                },
              );
            },
          ),
        if (DetailImigranController.to.isRujukRsPolri())
          ListTile(
            title: const Text("Berita Acara Serah Terima PMI Sakit"),
            onTap: () {
              Get.back();
              Get.toNamed(
                Routes.pdf,
                arguments: {
                  "title": "Berita Acara Serah Terima PMI Sakit",
                  "stream_url":
                      "${BaseClient.apiUrl}/api/pdf/rujuk-rs-polri/${DetailImigranController.to.imigran.value.rujukRsPolri?.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/rujuk-rs-polri/${DetailImigranController.to.imigran.value.rujukRsPolri?.id}?download=true"
                },
              );
            },
          ),
        if (DetailImigranController.to.isPulangMandiri())
          ListTile(
            title: const Text("Surat Permohonan Izin Pulang Mandiri"),
            onTap: () {
              Get.back();
              Get.toNamed(
                Routes.pdf,
                arguments: {
                  "title": "Surat Permohonan Izin Pulang Mandiri",
                  "stream_url":
                      "${BaseClient.apiUrl}/api/pdf/pulang-mandiri/${DetailImigranController.to.imigran.value.pulangMandiri?.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/pulang-mandiri/${DetailImigranController.to.imigran.value.pulangMandiri?.id}?download=true"
                },
              );
            },
          ),
        if (DetailImigranController.to.isJemputKeluarga())
          ListTile(
            title: const Text("Surat Pernyataan Penjemputan"),
            onTap: () {
              Get.back();
              Get.toNamed(
                Routes.pdf,
                arguments: {
                  "title": "Surat Pernyataan Penjemputan",
                  "stream_url":
                      "${BaseClient.apiUrl}/api/pdf/jemput-keluarga/${DetailImigranController.to.imigran.value.jemputKeluarga?.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/jemput-keluarga/${DetailImigranController.to.imigran.value.jemputKeluarga?.id}?download=true"
                },
              );
            },
          ),
        if (DetailImigranController.to.isJemputPihakLain())
          ListTile(
            title: const Text("Berita Acara Serah Terima PMI"),
            onTap: () {
              Get.back();
              Get.toNamed(
                Routes.pdf,
                arguments: {
                  "title": "Berita Acara Serah Terima PMI",
                  "stream_url":
                      "${BaseClient.apiUrl}/api/pdf/bast-pihak-lain/${DetailImigranController.to.imigran.value.jemputPihakLain?.bastPihakLain?.id}?download=false",
                  "download_url":
                      "${BaseClient.apiUrl}/api/pdf/bast-pihak-lain/${DetailImigranController.to.imigran.value.jemputPihakLain?.bastPihakLain?.id}?download=true"
                },
              );
            },
          ),
      ],
    ),
  );
}

void actionAntarArea() {
  Get.dialog(
    AlertDialog(
      title: Text(
          'Antar ke ${DetailImigranController.to.imigran.value.area?.antarArea?.toArea?.nama ?? ""}'),
      content: Text(
          'Anda yakin ingin mengantar ${DetailImigranController.to.imigran.value.nama ?? ""} ke ${DetailImigranController.to.imigran.value.area?.antarArea?.toArea?.nama ?? ""}"?'),
      actions: [
        TextButton(
          child: const Text('Ya'),
          onPressed: () async {
            Get.back();
            DetailImigranController.to.antarArea();
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

void actionKepulangan(context) {
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
            itemCount: DetailImigranController
                .to.imigran.value.area?.kepulangan?.length,
            itemBuilder: (context, index) {
              final kepulangan = DetailImigranController
                  .to.imigran.value.area?.kepulangan?[index];
              return ListTile(
                title: Text(kepulangan?.nama ?? ""),
                onTap: () async {
                  Get.back();
                  dynamic result;
                  result = await Get.toNamed(Routes.kepulangan, arguments: [
                    {'imigran': DetailImigranController.to.imigran.value},
                    {'kepulangan': kepulangan},
                  ]);
                  if (result != null) {
                    DetailImigranController.to.imigran.value =
                        result as Imigran;
                  } else {
                    DetailImigranController.to.imigran.value =
                        DetailImigranController.to.imigran.value;
                  }
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}

void actionUbahKepulangan() async {
  dynamic result;
  result = await Get.toNamed(Routes.kepulangan, arguments: [
    {'imigran': DetailImigranController.to.imigran.value},
    {'kepulangan': DetailImigranController.to.imigran.value.kepulangan},
  ]);
  if (result != null) {
    DetailImigranController.to.imigran.value = result as Imigran;
  } else {
    DetailImigranController.to.imigran.value =
        DetailImigranController.to.imigran.value;
  }
}

void actionTerlaksana() {
  Get.dialog(
    AlertDialog(
      title: const Text('Terlaksana'),
      content: Text(
          'Anda yakin ingin mengubah status "${DetailImigranController.to.imigran.value.nama ?? ""}" menjadi terlaksana?'),
      actions: [
        TextButton(
          child: const Text('Ya'),
          onPressed: () async {
            Get.back();
            await DetailImigranController.to.terlaksana();
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

void actionUbah() async {
  dynamic result;
  result = await Get.toNamed(Routes.editImigran, arguments: [
    {'area': DetailImigranController.to.imigran.value.area},
    {'layanan': DetailImigranController.to.imigran.value.layanan},
    {'imigran': DetailImigranController.to.imigran.value},
  ]);
  if (result != null) {
    DetailImigranController.to.imigran.value = result as Imigran;
  } else {
    DetailImigranController.to.imigran.value =
        DetailImigranController.to.imigran.value;
  }
}

void actionHapus() {
  Get.dialog(
    AlertDialog(
      title: const Text('Hapus'),
      content: Text(
          'Anda yakin ingin menghapus "${DetailImigranController.to.imigran.value.nama ?? ""}"?'),
      actions: [
        TextButton(
          child: const Text('Ya'),
          onPressed: () async {
            Get.back();
            await DetailImigranController.to.destroy();
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
