import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kepulangan/app/modules/kepulangan/views/form_darat_page.dart';
import 'package:kepulangan/app/modules/kepulangan/views/form_jemput_keluarga_page.dart';
import 'package:kepulangan/app/modules/kepulangan/views/form_jemput_pihak_lain_page.dart';
import 'package:kepulangan/app/modules/kepulangan/views/form_pulang_mandiri_page.dart';
import 'package:kepulangan/app/modules/kepulangan/views/form_udara_page.dart';
import 'package:kepulangan/app/modules/kepulangan/views/fotm_rujuk_rs_polri_page.dart';

import '../controllers/kepulangan_controller.dart';

class KepulanganView extends GetView<KepulanganController> {
  const KepulanganView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.kepulangan?.nama ?? ""),
        actions: [
          TextButton(
            onPressed: () {
              controller.save();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
      body: Form(
        key: controller.formState,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            if (controller.isDarat == true) const FormDaratPage(),
            if (controller.isUdara == true) const FormUdaraPage(),
            if (controller.isRujukRsPolri == true) const FormRujukRsPolriPage(),
            if (controller.isPulangMandiri == true)
              const FormPulangMandiriPage(),
            if (controller.isJemputKeluarga == true)
              const FormJemputKeluargaPage(),
            if (controller.isJemputPihakLain == true)
              const FormJemputPihakLainPage(),
          ],
        ),
      ),
    );
  }
}
