import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/data/models/imigran.dart';
import 'package:kepulangan/app/modules/imigran/controllers/imigran_controller.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/base_client.dart';
import 'package:kepulangan/app/widgets/complex_list_widget.dart';
import 'package:kepulangan/app/widgets/error_exception_widget.dart';
import 'package:kepulangan/app/widgets/no_data_found_widget.dart';

class SearchImigranPage extends SearchDelegate {
  SearchImigranPage() : super(searchFieldLabel: "Cari ...");

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
    return FutureBuilder<List<Imigran>>(
      future: ImigranController.to.search(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (ImigranController.to.listSearch.isEmpty) {
            return const NoDataFoundWidget(text: "Data tidak ditemukan");
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: ImigranController.to.listSearch.length,
            itemBuilder: (context, index) {
              final item = ImigranController.to.listSearch[index];
              return ComplexListWidget(
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.detailImigran, arguments: item);
                },
                headerLeftText: item.area?.nama ?? "",
                headerRightText: item.layanan?.nama ?? "",
                footerLeftText: item.tanggalKedatangan != null
                    ? DateFormat('dd-MM-yyyy', "id_ID").format(
                        DateTime.parse(item.tanggalKedatangan.toString()))
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
                      if (ImigranController.to.isCanAntarArea(item))
                        PopupMenuItem(
                          value: "antar_area",
                          child: Text(
                            "Antar ke ${item.area?.antarArea?.toArea?.nama ?? ""}",
                          ),
                        ),
                      if (ImigranController.to.isCanKepulangan(item))
                        const PopupMenuItem(
                          value: "kepulangan",
                          child: Text("Kepulangan"),
                        ),
                      if (ImigranController.to.isCanEditKepulangan(item))
                        const PopupMenuItem(
                          value: "ubah_kepulangan",
                          child: Text("Ubah Kepulangan"),
                        ),
                      if (ImigranController.to.isCanTerlaksana(item))
                        const PopupMenuItem(
                          value: "terlaksana",
                          child: Text("Terlaksana"),
                        ),
                      const PopupMenuItem(
                        value: "detail",
                        child: Text("Detail"),
                      ),
                      if (ImigranController.to.isCanEdit(item))
                        const PopupMenuItem(
                          value: "ubah",
                          child: Text("Ubah"),
                        ),
                      if (ImigranController.to.isCanDelete(item))
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
    return FutureBuilder<List<Imigran>>(
      future: ImigranController.to.search(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (ImigranController.to.listSearch.isEmpty) {
            return const NoDataFoundWidget(text: "Data tidak ditemukan");
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: ImigranController.to.listSearch.length,
            itemBuilder: (context, index) {
              final item = ImigranController.to.listSearch[index];
              return ComplexListWidget(
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.detailImigran, arguments: item);
                },
                headerLeftText: item.area?.nama ?? "",
                headerRightText: item.layanan?.nama ?? "",
                footerLeftText: item.tanggalKedatangan != null
                    ? DateFormat('dd-MM-yyyy', "id_ID").format(
                        DateTime.parse(item.tanggalKedatangan.toString()))
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
                      if (ImigranController.to.isCanAntarArea(item))
                        PopupMenuItem(
                          value: "antar_area",
                          child: Text(
                            "Antar ke ${item.area?.antarArea?.toArea?.nama ?? ""}",
                          ),
                        ),
                      if (ImigranController.to.isCanKepulangan(item))
                        const PopupMenuItem(
                          value: "kepulangan",
                          child: Text("Kepulangan"),
                        ),
                      if (ImigranController.to.isCanEditKepulangan(item))
                        const PopupMenuItem(
                          value: "ubah_kepulangan",
                          child: Text("Ubah Kepulangan"),
                        ),
                      if (ImigranController.to.isCanTerlaksana(item))
                        const PopupMenuItem(
                          value: "terlaksana",
                          child: Text("Terlaksana"),
                        ),
                      const PopupMenuItem(
                        value: "detail",
                        child: Text("Detail"),
                      ),
                      if (ImigranController.to.isCanEdit(item))
                        const PopupMenuItem(
                          value: "ubah",
                          child: Text("Ubah"),
                        ),
                      if (ImigranController.to.isCanDelete(item))
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
            ImigranController.to.antarArea(imigran);
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
                  Get.back();
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
  Get.back();
  Get.toNamed(Routes.kepulangan, arguments: [
    {'imigran': imigran},
    {'kepulangan': imigran.kepulangan},
  ]);
}

void actionTerlaksana(Imigran imigran) {
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
            await ImigranController.to.terlaksana(imigran);
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

void actionDetail(Imigran imigran) {
  Get.back();
  Get.toNamed(Routes.detailImigran, arguments: imigran);
}

void actionUbah(Imigran imigran) {
  Get.back();
  Get.toNamed(Routes.editImigran, arguments: [
    {'area': imigran.area},
    {'layanan': imigran.layanan},
    {'imigran': imigran},
  ]);
}

void actionHapus(Imigran imigran) {
  Get.dialog(
    AlertDialog(
      title: const Text('Hapus'),
      content: Text('Anda yakin ingin menghapus "${imigran.nama ?? ""}"?'),
      actions: [
        TextButton(
          child: const Text('Ya'),
          onPressed: () async {
            Get.back();
            await ImigranController.to.destroy(imigran);
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
