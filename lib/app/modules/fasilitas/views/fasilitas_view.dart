import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kepulangan/app/modules/bast_darat/views/bast_darat_view.dart';
import 'package:kepulangan/app/modules/bast_darat/views/search_bast_darat_page.dart';
import 'package:kepulangan/app/modules/bast_makan/views/bast_makan_view.dart';
import 'package:kepulangan/app/modules/bast_makan/views/search_bast_makan_page.dart';
import 'package:kepulangan/app/modules/bast_pihak_lain/views/bast_pihak_lain_view.dart';
import 'package:kepulangan/app/modules/bast_pihak_lain/views/search_bast_pihak_lain_page.dart';
import 'package:kepulangan/app/modules/bast_udara/views/bast_udara_view.dart';
import 'package:kepulangan/app/modules/bast_udara/views/search_bast_udara_page.dart';
import 'package:kepulangan/app/routes/app_pages.dart';

import '../controllers/fasilitas_controller.dart';

class FasilitasView extends GetView<FasilitasController> {
  const FasilitasView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fasilitas'),
        actions: const [
          CreateButton(),
          SearchButton(),
        ],
        bottom: TabBar(
          controller: controller.tabController,
          tabs: const [
            Tab(text: "Makan"),
            Tab(text: "Darat"),
            Tab(text: "Udara"),
            Tab(text: "Pihak Lain"),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: const [
          BastMakanView(),
          BastDaratView(),
          BastUdaraView(),
          BastPihakLainView(),
        ],
      ),
    );
  }
}

class SearchButton extends GetView<FasilitasController> {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (controller.tabController.index == 0) {
          showSearch(context: context, delegate: SearchBastMakanPage());
        }
        if (controller.tabController.index == 1) {
          showSearch(context: context, delegate: SearchBastDaratPage());
        }
        if (controller.tabController.index == 2) {
          showSearch(context: context, delegate: SearchBastUdaraPage());
        }
        if (controller.tabController.index == 3) {
          showSearch(context: context, delegate: SearchBastPihakLainPage());
        }
      },
      icon: const Icon(Icons.search),
    );
  }
}

class CreateButton extends GetView<FasilitasController> {
  const CreateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (controller.tabController.index == 0) {
          Get.toNamed(Routes.createBastMakan);
        }
        if (controller.tabController.index == 1) {
          Get.toNamed(Routes.createBastDarat);
        }
        if (controller.tabController.index == 2) {
          Get.toNamed(Routes.createBastUdara);
        }
        if (controller.tabController.index == 3) {
          Get.toNamed(Routes.createBastPihakLain);
        }
      },
      child: const Text('Tambah'),
    );
  }
}
