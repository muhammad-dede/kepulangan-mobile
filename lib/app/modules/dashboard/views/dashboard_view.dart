import 'package:flutter/material.dart';

import 'package:iconly/iconly.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/area.dart';
import 'package:kepulangan/app/data/models/chart.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/widgets/error_exception_widget.dart';
import 'package:kepulangan/app/widgets/no_data_found_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                onPressed: () {
                  Get.toNamed(Routes.profil);
                },
                icon: const CircleAvatar(
                  child: Icon(Icons.person_4_outlined),
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshData();
            },
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                const Header(),
                if (controller.listArea.isNotEmpty) const MenuArea(),
                const MenuTotal(),
                const ChartJenisKelamin(
                  idLayanan: 1,
                  namaLayanan: "Pmi",
                ),
                const ChartMasalah(
                  idLayanan: 1,
                  namaLayanan: "Pmi",
                ),
                const ChartNegara(
                  idLayanan: 1,
                  namaLayanan: "Pmi",
                ),
                const ChartProvinsi(
                  idLayanan: 1,
                  namaLayanan: "Pmi",
                ),
                const ChartKabKota(
                  idLayanan: 1,
                  namaLayanan: "Pmi",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Header extends GetView<DashboardController> {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Container(
          margin: const EdgeInsets.only(left: 6, top: 0, right: 6, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, ${AuthService.to.auth.value.nama ?? "User"}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text("Selamat datang!"),
            ],
          ),
        );
      },
    );
  }
}

class MenuArea extends GetView<DashboardController> {
  const MenuArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return GridView.builder(
          padding: const EdgeInsets.only(top: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1 / 1,
          ),
          itemCount: controller.listArea.length,
          itemBuilder: (context, index) {
            final item = controller.listArea[index];
            return GestureDetector(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 25,
                    child: item.id == 1
                        ? const Icon(IconlyLight.discount)
                        : item.id == 2
                            ? const Icon(IconlyLight.star)
                            : item.id == 3
                                ? const Icon(IconlyLight.ticket_star)
                                : const Icon(IconlyLight.ticket),
                  ),
                  const SizedBox(height: 10),
                  Text(item.nama ?? ""),
                ],
              ),
              onTap: () {
                showLayanan(context, item);
              },
            );
          },
        );
      },
    );
  }
}

class MenuTotal extends GetView<DashboardController> {
  const MenuTotal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return GridView(
          padding: const EdgeInsets.only(bottom: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.5 / 1.5,
          ),
          children: [
            GestureDetector(
              onTap: () {
                statistikDetail(1, "PMI");
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              controller.total.value.totalPmi == null
                                  ? "0"
                                  : controller.total.value.totalPmi.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const CircleAvatar(
                              child: Icon(
                                IconlyLight.document,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('Total PMI'),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                statistikDetail(5, "CPMI");
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              controller.total.value.totalCpmi == null
                                  ? "0"
                                  : controller.total.value.totalCpmi.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const CircleAvatar(
                              child: Icon(
                                IconlyLight.document,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('Total CPMI'),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                statistikDetail(2, "ABK");
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              controller.total.value.totalAbk == null
                                  ? "0"
                                  : controller.total.value.totalAbk.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const CircleAvatar(
                              child: Icon(
                                IconlyLight.document,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('Total ABK'),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                statistikDetail(6, "Jenazah");
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              controller.total.value.totalJenazah == null
                                  ? "0"
                                  : controller.total.value.totalJenazah
                                      .toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const CircleAvatar(
                              child: Icon(
                                IconlyLight.document,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('Total Jenazah'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ChartJenisKelamin extends GetView<DashboardController> {
  const ChartJenisKelamin({
    super.key,
    required this.idLayanan,
    required this.namaLayanan,
  });

  final int? idLayanan;
  final String? namaLayanan;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text('$namaLayanan Berdasarkan Jenis Kelamin'),
            ),
          ),
          FutureBuilder<List<Chart>>(
            future: controller.getChartJenisKelamin(idLayanan),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.44,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ErrorExceptionWidget(
                    text: snapshot.error.toString(),
                  ),
                );
              }
              if (snapshot.hasData) {
                return SfCartesianChart(
                  series: [
                    ColumnSeries(
                      dataSource: snapshot.data,
                      xValueMapper: (Chart data, _) => data.label,
                      yValueMapper: (Chart data, _) => data.value,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      emptyPointSettings:
                          EmptyPointSettings(mode: EmptyPointMode.average),
                    ),
                  ],
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryXAxis: CategoryAxis(
                    autoScrollingMode: AutoScrollingMode.start,
                    autoScrollingDelta: 2,
                  ),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePanning: true,
                  ),
                );
              }
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: NoDataFoundWidget(text: "Data tidak ditemukan"),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ChartMasalah extends GetView<DashboardController> {
  const ChartMasalah({
    super.key,
    required this.idLayanan,
    required this.namaLayanan,
  });

  final int? idLayanan;
  final String? namaLayanan;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text('$namaLayanan Berdasarkan Masalah'),
            ),
          ),
          FutureBuilder<List<Chart>>(
            future: controller.getChartMasalah(idLayanan),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.44,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ErrorExceptionWidget(
                    text: snapshot.error.toString(),
                  ),
                );
              }
              if (snapshot.hasData) {
                return SfCartesianChart(
                  series: [
                    ColumnSeries(
                      dataSource: snapshot.data,
                      xValueMapper: (Chart data, _) => data.label,
                      yValueMapper: (Chart data, _) => data.value,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      emptyPointSettings:
                          EmptyPointSettings(mode: EmptyPointMode.average),
                    ),
                  ],
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryXAxis: CategoryAxis(
                    autoScrollingMode: AutoScrollingMode.start,
                    autoScrollingDelta: 4,
                  ),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePanning: true,
                  ),
                );
              }
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: NoDataFoundWidget(text: "Data tidak ditemukan"),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ChartNegara extends GetView<DashboardController> {
  const ChartNegara({
    super.key,
    required this.idLayanan,
    required this.namaLayanan,
  });

  final int? idLayanan;
  final String? namaLayanan;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                  '$namaLayanan Berdasarkan Negara ${idLayanan == 5 ? "Tujuan" : "Penempatan"}'),
            ),
          ),
          FutureBuilder<List<Chart>>(
            future: controller.getChartNegara(idLayanan),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.44,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ErrorExceptionWidget(
                    text: snapshot.error.toString(),
                  ),
                );
              }
              if (snapshot.hasData) {
                return SfCartesianChart(
                  series: [
                    ColumnSeries(
                      dataSource: snapshot.data,
                      xValueMapper: (Chart data, _) => data.label,
                      yValueMapper: (Chart data, _) => data.value,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      emptyPointSettings:
                          EmptyPointSettings(mode: EmptyPointMode.average),
                    ),
                  ],
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryXAxis: CategoryAxis(
                    autoScrollingMode: AutoScrollingMode.start,
                    autoScrollingDelta: 4,
                  ),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePanning: true,
                  ),
                );
              }
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: NoDataFoundWidget(text: "Data tidak ditemukan"),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ChartProvinsi extends GetView<DashboardController> {
  const ChartProvinsi({
    super.key,
    required this.idLayanan,
    required this.namaLayanan,
  });

  final int? idLayanan;
  final String? namaLayanan;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text('$namaLayanan Berdasarkan Provinsi'),
            ),
          ),
          FutureBuilder<List<Chart>>(
            future: controller.getChartProvinsi(idLayanan),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.44,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ErrorExceptionWidget(
                    text: snapshot.error.toString(),
                  ),
                );
              }
              if (snapshot.hasData) {
                return SfCartesianChart(
                  series: [
                    ColumnSeries(
                      dataSource: snapshot.data,
                      xValueMapper: (Chart data, _) => data.label,
                      yValueMapper: (Chart data, _) => data.value,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      emptyPointSettings:
                          EmptyPointSettings(mode: EmptyPointMode.average),
                    ),
                  ],
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryXAxis: CategoryAxis(
                    autoScrollingMode: AutoScrollingMode.start,
                    autoScrollingDelta: 4,
                  ),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePanning: true,
                  ),
                );
              }
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: NoDataFoundWidget(text: "Data tidak ditemukan"),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ChartKabKota extends GetView<DashboardController> {
  const ChartKabKota({
    super.key,
    required this.idLayanan,
    required this.namaLayanan,
  });

  final int? idLayanan;
  final String? namaLayanan;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text('$namaLayanan Berdasarkan Kabupaten/Kota'),
            ),
          ),
          FutureBuilder<List<Chart>>(
            future: controller.getChartKabKota(idLayanan),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.44,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ErrorExceptionWidget(
                    text: snapshot.error.toString(),
                  ),
                );
              }
              if (snapshot.hasData) {
                return SfCartesianChart(
                  series: [
                    ColumnSeries(
                      dataSource: snapshot.data,
                      xValueMapper: (Chart data, _) => data.label,
                      yValueMapper: (Chart data, _) => data.value,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      emptyPointSettings:
                          EmptyPointSettings(mode: EmptyPointMode.average),
                    ),
                  ],
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryXAxis: CategoryAxis(
                    autoScrollingMode: AutoScrollingMode.start,
                    autoScrollingDelta: 4,
                  ),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePanning: true,
                  ),
                );
              }
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: NoDataFoundWidget(text: "Data tidak ditemukan"),
              );
            },
          ),
        ],
      ),
    );
  }
}

void statistikDetail(
  int? idLayanan,
  String? namaLayanan,
) {
  Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: false,
    enableDrag: false,
    Scaffold(
      appBar: AppBar(
        title: Text("Statistik Layanan $namaLayanan"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          ChartJenisKelamin(
            idLayanan: idLayanan,
            namaLayanan: namaLayanan,
          ),
          if (idLayanan != 6)
            ChartMasalah(
              idLayanan: idLayanan,
              namaLayanan: namaLayanan,
            ),
          ChartNegara(
            idLayanan: idLayanan,
            namaLayanan: namaLayanan,
          ),
          ChartProvinsi(
            idLayanan: idLayanan,
            namaLayanan: namaLayanan,
          ),
          ChartKabKota(
            idLayanan: idLayanan,
            namaLayanan: namaLayanan,
          ),
        ],
      ),
    ),
  );
}

void showLayanan(context, Area? item) {
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
            'Pilih Layanan',
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
        for (var layanan in item!.layanan!)
          ListTile(
            title: Text(layanan.nama ?? ""),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.createImigran, arguments: [
                {'area': item},
                {'layanan': layanan},
              ]);
            },
          ),
      ],
    ),
  );
}