import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/widgets/button_widget.dart';
import 'package:kepulangan/app/widgets/date_picker_widget.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';

import '../controllers/laporan_controller.dart';

class LaporanView extends GetView<LaporanController> {
  const LaporanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LaporanController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Laporan Pelayanan'),
          ),
          body: Form(
            key: controller.formState,
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                const InputStartDate(),
                const InputEndDate(),
                const InputJenisLaporan(),
                if (AuthService.to.isAdmin.isTrue &&
                    controller.jenisLaporan == 0)
                  const InputGroup(),
                const ButtonExport(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class InputStartDate extends GetView<LaporanController> {
  const InputStartDate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DatePickerWidget(
        labelText: "Tanggal Awal",
        controller: controller.startDateController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () async {
          DateTime? datePicker = await showDatePicker(
            context: Get.context!,
            initialDate: controller.startDate ?? DateTime.now(),
            firstDate: DateTime(1945),
            lastDate: DateTime(DateTime.now().year + 1),
          );
          if (datePicker != null) {
            controller.startDate = datePicker;
            controller.startDateController.text =
                DateFormat('dd-MM-yyyy').format(datePicker).toString();
          }
        },
      ),
    );
  }
}

class InputEndDate extends GetView<LaporanController> {
  const InputEndDate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DatePickerWidget(
        labelText: "Tanggal Akhir",
        controller: controller.endDateController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () async {
          DateTime? datePicker = await showDatePicker(
            context: Get.context!,
            initialDate: controller.endDate ?? DateTime.now(),
            firstDate: DateTime(1945),
            lastDate: DateTime(DateTime.now().year + 1),
          );
          if (datePicker != null) {
            controller.endDate = datePicker;
            controller.endDateController.text =
                DateFormat('dd-MM-yyyy').format(datePicker).toString();
          }
        },
      ),
    );
  }
}

class InputJenisLaporan extends GetView<LaporanController> {
  const InputJenisLaporan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Jenis Laporan",
        readOnly: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        controller: controller.jenisLaporanController,
        obscureText: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () {
          Get.bottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            GetBuilder<LaporanController>(
              builder: (controller) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Pilih Jenis Laporan',
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
                        itemCount: controller.listJenisLaporan.length,
                        itemBuilder: (context, index) {
                          final item = controller.listJenisLaporan[index];
                          return ListTile(
                            title: Text(item['label'] ?? ""),
                            trailing: controller.jenisLaporan == item["value"]
                                ? const Icon(Icons.check)
                                : null,
                            onTap: () {
                              controller.jenisLaporan = item['value'];
                              controller.url = item['url'];
                              controller.jenisLaporanController.text =
                                  item['label'] ?? "";
                              controller.update();
                              Get.back();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class InputGroup extends GetView<LaporanController> {
  const InputGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Group",
        readOnly: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        controller: controller.groupController,
        obscureText: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () {
          controller.getGroup();
          Get.bottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            GetBuilder<LaporanController>(
              builder: (container) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Pilih Group',
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
                      child: controller.isLoading == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : controller.listGroup != null
                              ? ListView.builder(
                                  itemCount: controller.listGroup!.length,
                                  itemBuilder: (context, index) {
                                    final item = controller.listGroup![index];
                                    return ListTile(
                                      title: Text(item.nama ?? ""),
                                      trailing: controller.idGroup == item.id
                                          ? const Icon(Icons.check)
                                          : null,
                                      onTap: () {
                                        controller.idGroup = item.id;
                                        controller.groupController.text =
                                            item.nama!;
                                        controller.update();
                                        Get.back();
                                      },
                                    );
                                  },
                                )
                              : Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.getGroup();
                                      controller.update();
                                    },
                                    child: const Icon(Icons.refresh, size: 40),
                                  ),
                                ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ButtonExport extends GetView<LaporanController> {
  const ButtonExport({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ButtonWidget(
        backgroundColor: Theme.of(context).colorScheme.primary,
        labelButton: "Export",
        onPressed: () {
          controller.save();
        },
      ),
    );
  }
}
