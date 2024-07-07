import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:kepulangan/app/modules/dashboard/views/dashboard_view.dart';
import 'package:kepulangan/app/modules/fasilitas/views/fasilitas_view.dart';
import 'package:kepulangan/app/modules/imigran/views/imigran_view.dart';
import 'package:kepulangan/app/modules/pengaturan/views/pengaturan_view.dart';

import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: const [
          DashboardView(),
          ImigranView(),
          FasilitasView(),
          PengaturanView(),
        ][controller.pageIndex.value],
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(
              icon: Icon(IconlyLight.home),
              selectedIcon: Icon(IconlyBold.home),
              label: "Dashboard",
            ),
            NavigationDestination(
              icon: Icon(IconlyLight.document),
              selectedIcon: Icon(IconlyBold.document),
              label: "Pelayanan",
            ),
            NavigationDestination(
              icon: Icon(IconlyLight.activity),
              selectedIcon: Icon(IconlyBold.activity),
              label: "Fasilitas",
            ),
            NavigationDestination(
              icon: Icon(IconlyLight.category),
              selectedIcon: Icon(IconlyBold.category),
              label: "Pengaturan",
            ),
          ],
          selectedIndex: controller.pageIndex.value,
          onDestinationSelected: (int index) {
            controller.pageIndex.value = index;
          },
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
