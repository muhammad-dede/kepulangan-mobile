import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/permission_service.dart';
import 'package:kepulangan/app/widgets/date_picker_widget.dart';
import 'package:kepulangan/app/widgets/image_picker_widget.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';

import '../controllers/create_imigran_controller.dart';

class CreateImigranView extends GetView<CreateImigranController> {
  const CreateImigranView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateImigranController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.area?.nama ?? ""),
            actions: [
              TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
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
                const Header(),
                const InputBrafaks(),
                const InputPaspor(),
                const InputNama(),
                const InputJenisKelamin(),
                const InputNegara(),
                const InputProvinsi(),
                const InputKabKota(),
                const InputAlamat(),
                const InputNoTelp(),
                const InputJabatan(),
                const InputTanggalKedatangan(),
                if (controller.isJenazah == true) const InputKepulangan(),
                if (controller.isPmi == true && AuthService.to.isAdmin.isTrue)
                  const InputGroup(),
                if (controller.isPmi == true) const InputMasalah(),
                if (controller.isJenazah == true) const InputCargo(),
                if (controller.isPmi == true) const InputFotoPmi(),
                if (controller.isJenazah == true) const InputFotoJenazah(),
                const InputFotoPaspor(),
                if (controller.isJenazah == true) const InputFotoBrafaks(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Header extends GetView<CreateImigranController> {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: Card(
        child: ListTile(
          title: const Text('Layanan'),
          subtitle: Text(
            controller.layanan?.nama ?? "-",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class InputBrafaks extends GetView<CreateImigranController> {
  const InputBrafaks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Brafaks",
        readOnly: false,
        controller: controller.brafaksController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class InputPaspor extends GetView<CreateImigranController> {
  const InputPaspor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Paspor",
        readOnly: false,
        controller: controller.pasporController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class InputNama extends GetView<CreateImigranController> {
  const InputNama({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Nama",
        readOnly: false,
        controller: controller.namaController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class InputJenisKelamin extends GetView<CreateImigranController> {
  const InputJenisKelamin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Jenis Kelamin",
        readOnly: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        controller: controller.jenisKelaminController,
        obscureText: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () {
          controller.getJenisKelamin();
          Get.bottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            GetBuilder<CreateImigranController>(
              builder: (controller) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Pilih Jenis Kelamin',
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
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: TextFormFieldWidget(
                        readOnly: false,
                        hintText: "Cari",
                        prefixIcon: const Icon(Icons.search),
                        obscureText: false,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            controller.listJenisKelamin = controller
                                .listAllJenisKelamin!
                                .where((item) => item.nama!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          } else {
                            controller.listJenisKelamin =
                                controller.listAllJenisKelamin;
                          }
                          controller.update();
                        },
                      ),
                    ),
                    Expanded(
                      child: controller.isLoadingReferensi == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : controller.listJenisKelamin!.isNotEmpty
                              ? ListView.builder(
                                  itemCount:
                                      controller.listJenisKelamin!.length,
                                  itemBuilder: (context, index) {
                                    final item =
                                        controller.listJenisKelamin![index];
                                    return ListTile(
                                      title: Text(item.nama ?? ""),
                                      trailing:
                                          controller.idJenisKelamin == item.id
                                              ? const Icon(Icons.check)
                                              : null,
                                      onTap: () {
                                        controller.idJenisKelamin = item.id;
                                        controller.jenisKelaminController.text =
                                            item.nama ?? "";
                                        controller.update();
                                        Get.back();
                                      },
                                    );
                                  },
                                )
                              : Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.getJenisKelamin();
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

class InputNegara extends GetView<CreateImigranController> {
  const InputNegara({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText:
            "Negara ${controller.layanan?.id == 5 ? "Tujuan" : "Penempatan"}",
        readOnly: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        controller: controller.negaraController,
        obscureText: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () {
          controller.getNegara();
          Get.bottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            GetBuilder<CreateImigranController>(
              builder: (controller) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Pilih Negara',
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
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: TextFormFieldWidget(
                        readOnly: false,
                        hintText: "Cari",
                        prefixIcon: const Icon(Icons.search),
                        obscureText: false,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            controller.listNegara = controller.listAllNegara!
                                .where((item) => item.nama!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          } else {
                            controller.listNegara = controller.listAllNegara;
                          }
                          controller.update();
                        },
                      ),
                    ),
                    Expanded(
                      child: controller.isLoadingReferensi == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : controller.listNegara!.isNotEmpty
                              ? ListView.builder(
                                  itemCount: controller.listNegara!.length,
                                  itemBuilder: (context, index) {
                                    final item = controller.listNegara![index];
                                    return ListTile(
                                      title: Text(item.nama ?? ""),
                                      subtitle: Text(
                                          item.subKawasan?.kawasan?.nama ?? ""),
                                      trailing: controller.idNegara == item.id
                                          ? const Icon(Icons.check)
                                          : null,
                                      onTap: () {
                                        controller.idNegara = item.id;
                                        controller.negaraController.text =
                                            item.nama ?? "";
                                        controller.idSubKawasan =
                                            item.subKawasan?.id;
                                        controller.idKawasan =
                                            item.subKawasan?.kawasan?.id;
                                        controller.update();
                                        Get.back();
                                      },
                                    );
                                  },
                                )
                              : Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.getNegara();
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

class InputProvinsi extends GetView<CreateImigranController> {
  const InputProvinsi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Provinsi",
        readOnly: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        controller: controller.provinsiController,
        obscureText: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () {
          controller.getProvinsi();
          Get.bottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            GetBuilder<CreateImigranController>(
              builder: (controller) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Pilih Provinsi',
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
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: TextFormFieldWidget(
                        readOnly: false,
                        hintText: "Cari",
                        prefixIcon: const Icon(Icons.search),
                        obscureText: false,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            controller.listProvinsi = controller
                                .listAllProvinsi!
                                .where((item) => item.nama!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          } else {
                            controller.listProvinsi =
                                controller.listAllProvinsi;
                          }
                          controller.update();
                        },
                      ),
                    ),
                    Expanded(
                      child: controller.isLoadingReferensi == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : controller.listProvinsi!.isNotEmpty
                              ? ListView.builder(
                                  itemCount: controller.listProvinsi!.length,
                                  itemBuilder: (context, index) {
                                    final item =
                                        controller.listProvinsi![index];
                                    return ListTile(
                                      title: Text(item.nama ?? ""),
                                      trailing: controller.idProvinsi == item.id
                                          ? const Icon(Icons.check)
                                          : null,
                                      onTap: () {
                                        if (controller.idProvinsi != item.id) {
                                          controller.idKabKota = null;
                                          controller.kabKotaController.clear();
                                        }
                                        controller.idProvinsi = item.id;
                                        controller.provinsiController.text =
                                            item.nama ?? "";
                                        controller.update();
                                        Get.back();
                                      },
                                    );
                                  },
                                )
                              : Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.getProvinsi();
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

class InputKabKota extends GetView<CreateImigranController> {
  const InputKabKota({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Kabupaten/Kota",
        readOnly: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        controller: controller.kabKotaController,
        obscureText: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () {
          controller.getKabKota();
          Get.bottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            GetBuilder<CreateImigranController>(
              builder: (controller) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Pilih Kabupaten/Kota',
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
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: TextFormFieldWidget(
                        readOnly: false,
                        hintText: "Cari",
                        prefixIcon: const Icon(Icons.search),
                        obscureText: false,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            controller.listKabKota = controller.listAllKabKota!
                                .where((item) => item.nama!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          } else {
                            controller.listKabKota = controller.listAllKabKota;
                          }
                          controller.update();
                        },
                      ),
                    ),
                    Expanded(
                      child: controller.isLoadingReferensi == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : controller.listKabKota!.isNotEmpty
                              ? ListView.builder(
                                  itemCount: controller.listKabKota!.length,
                                  itemBuilder: (context, index) {
                                    final item = controller.listKabKota![index];
                                    return ListTile(
                                      title: Text(item.nama ?? ""),
                                      trailing: controller.idKabKota == item.id
                                          ? const Icon(Icons.check)
                                          : null,
                                      onTap: () {
                                        controller.idKabKota = item.id;
                                        controller.kabKotaController.text =
                                            item.nama ?? "";
                                        controller.update();
                                        Get.back();
                                      },
                                    );
                                  },
                                )
                              : Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.getKabKota();
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

class InputAlamat extends GetView<CreateImigranController> {
  const InputAlamat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Alamat",
        helperText: "(Optional)",
        readOnly: false,
        controller: controller.alamatController,
        obscureText: false,
        keyboardType: TextInputType.text,
      ),
    );
  }
}

class InputNoTelp extends GetView<CreateImigranController> {
  const InputNoTelp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "No. Telepon",
        helperText: "(Optional)",
        readOnly: false,
        controller: controller.noTelpController,
        obscureText: false,
        keyboardType: TextInputType.phone,
      ),
    );
  }
}

class InputJabatan extends GetView<CreateImigranController> {
  const InputJabatan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Jabatan",
        readOnly: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        controller: controller.jabatanController,
        obscureText: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () {
          controller.getJabatan();
          Get.bottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            GetBuilder<CreateImigranController>(
              builder: (controller) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Pilih Jabatan',
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
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: TextFormFieldWidget(
                        readOnly: false,
                        hintText: "Cari",
                        prefixIcon: const Icon(Icons.search),
                        obscureText: false,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            controller.listJabatan = controller.listAllJabatan!
                                .where((item) => item.nama!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          } else {
                            controller.listJabatan = controller.listAllJabatan;
                          }
                          controller.update();
                        },
                      ),
                    ),
                    Expanded(
                      child: controller.isLoadingReferensi == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : controller.listJabatan!.isNotEmpty
                              ? ListView.builder(
                                  itemCount: controller.listJabatan!.length,
                                  itemBuilder: (context, index) {
                                    final item = controller.listJabatan![index];
                                    return ListTile(
                                      title: Text(item.nama ?? ""),
                                      trailing: controller.idJabatan == item.id
                                          ? const Icon(Icons.check)
                                          : null,
                                      onTap: () {
                                        controller.idJabatan = item.id;
                                        controller.jabatanController.text =
                                            item.nama ?? "";
                                        controller.update();
                                        Get.back();
                                      },
                                    );
                                  },
                                )
                              : Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.getJabatan();
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

class InputTanggalKedatangan extends GetView<CreateImigranController> {
  const InputTanggalKedatangan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DatePickerWidget(
        labelText: "Tanggal Kedatangan",
        controller: controller.tanggalKedatanganController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () async {
          DateTime? datePicker = await showDatePicker(
            context: Get.context!,
            initialDate: controller.tanggalKedatangan ?? DateTime.now(),
            firstDate: DateTime(1945),
            lastDate: DateTime(DateTime.now().year + 1),
          );
          if (datePicker != null) {
            controller.tanggalKedatangan = datePicker;
            controller.tanggalKedatanganController.text =
                DateFormat('dd-MM-yyyy').format(datePicker).toString();
          }
        },
      ),
    );
  }
}

class InputGroup extends GetView<CreateImigranController> {
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
            GetBuilder<CreateImigranController>(
              builder: (controller) {
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
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: TextFormFieldWidget(
                        readOnly: false,
                        hintText: "Cari",
                        prefixIcon: const Icon(Icons.search),
                        obscureText: false,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            controller.listGroup = controller.listAllGroup!
                                .where((item) => item.nama!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          } else {
                            controller.listGroup = controller.listAllGroup;
                          }
                          controller.update();
                        },
                      ),
                    ),
                    Expanded(
                      child: controller.isLoadingReferensi == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : controller.listGroup!.isNotEmpty
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
                                            item.nama ?? "";
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

class InputMasalah extends GetView<CreateImigranController> {
  const InputMasalah({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Masalah",
        readOnly: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        controller: controller.masalahController,
        obscureText: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () {
          controller.getMasalah();
          Get.bottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            GetBuilder<CreateImigranController>(
              builder: (controller) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Pilih Masalah',
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
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: TextFormFieldWidget(
                        readOnly: false,
                        hintText: "Cari",
                        prefixIcon: const Icon(Icons.search),
                        obscureText: false,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            controller.listMasalah = controller.listAllMasalah!
                                .where((item) => item.nama!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          } else {
                            controller.listMasalah = controller.listAllMasalah;
                          }
                          controller.update();
                        },
                      ),
                    ),
                    Expanded(
                      child: controller.isLoadingReferensi == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : controller.listMasalah!.isNotEmpty
                              ? ListView.builder(
                                  itemCount: controller.listMasalah!.length,
                                  itemBuilder: (context, index) {
                                    final item = controller.listMasalah![index];
                                    return ListTile(
                                      title: Text(item.nama ?? ""),
                                      trailing: controller.idMasalah == item.id
                                          ? const Icon(Icons.check)
                                          : null,
                                      onTap: () {
                                        controller.idMasalah = item.id;
                                        controller.masalahController.text =
                                            item.nama ?? "";
                                        controller.update();
                                        Get.back();
                                      },
                                    );
                                  },
                                )
                              : Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.getMasalah();
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

class InputKepulangan extends GetView<CreateImigranController> {
  const InputKepulangan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Kepulangan",
        readOnly: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        controller: controller.kepulanganController,
        obscureText: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () {
          controller.getKepulangan();
          Get.bottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            GetBuilder<CreateImigranController>(
              builder: (controller) {
                return Column(
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
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: TextFormFieldWidget(
                        readOnly: false,
                        hintText: "Cari",
                        prefixIcon: const Icon(Icons.search),
                        obscureText: false,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            controller.listKepulangan = controller
                                .listAllKepulangan!
                                .where((item) => item.nama!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          } else {
                            controller.listKepulangan =
                                controller.listAllKepulangan;
                          }
                          controller.update();
                        },
                      ),
                    ),
                    Expanded(
                      child: controller.isLoadingReferensi == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : controller.listKepulangan!.isNotEmpty
                              ? ListView.builder(
                                  itemCount: controller.listKepulangan!.length,
                                  itemBuilder: (context, index) {
                                    final item =
                                        controller.listKepulangan![index];
                                    return ListTile(
                                      title: Text(item.nama ?? ""),
                                      trailing:
                                          controller.idKepulangan == item.id
                                              ? const Icon(Icons.check)
                                              : null,
                                      onTap: () {
                                        controller.idKepulangan = item.id;
                                        controller.kepulanganController.text =
                                            item.nama ?? "";
                                        controller.update();
                                        Get.back();
                                      },
                                    );
                                  },
                                )
                              : Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.getKepulangan();
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

class InputCargo extends GetView<CreateImigranController> {
  const InputCargo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Cargo",
        readOnly: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        controller: controller.cargoController,
        obscureText: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
        onTap: () {
          controller.getCargo();
          Get.bottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            GetBuilder<CreateImigranController>(
              builder: (controller) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Pilih Cargo',
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
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: TextFormFieldWidget(
                        readOnly: false,
                        hintText: "Cari",
                        prefixIcon: const Icon(Icons.search),
                        obscureText: false,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            controller.listCargo = controller.listAllCargo!
                                .where((item) => item.nama!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          } else {
                            controller.listCargo = controller.listAllCargo;
                          }
                          controller.update();
                        },
                      ),
                    ),
                    Expanded(
                      child: controller.isLoadingReferensi == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : controller.listCargo!.isNotEmpty
                              ? ListView.builder(
                                  itemCount: controller.listCargo!.length,
                                  itemBuilder: (context, index) {
                                    final item = controller.listCargo![index];
                                    return ListTile(
                                      title: Text(item.nama ?? ""),
                                      trailing: controller.idCargo == item.id
                                          ? const Icon(Icons.check)
                                          : null,
                                      onTap: () {
                                        controller.idCargo = item.id;
                                        controller.cargoController.text =
                                            item.nama ?? "";
                                        controller.update();
                                        Get.back();
                                      },
                                    );
                                  },
                                )
                              : Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.getCargo();
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

class InputFotoPmi extends GetView<CreateImigranController> {
  const InputFotoPmi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateImigranController>(
      builder: (controller) {
        return ImagePickerWidget(
          title: "Foto PMI",
          imageFile: controller.fotoPmi,
          onDelete: () {
            controller.fotoPmi = null;
            controller.update();
          },
          onTapCamera: () async {
            await PermissionService.to.cameraRequest().then((value) {
              if (value == true) {
                controller.getFotoPmi(ImageSource.camera);
              }
            });
            Get.back();
          },
          onTapGalery: () async {
            await PermissionService.to.storageRequest().then((value) {
              if (value == true) {
                controller.getFotoPmi(ImageSource.gallery);
              }
            });
            Get.back();
          },
        );
      },
    );
  }
}

class InputFotoJenazah extends GetView<CreateImigranController> {
  const InputFotoJenazah({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateImigranController>(
      builder: (controller) {
        return ImagePickerWidget(
          title: "Foto Jenazah",
          imageFile: controller.fotoJenazah,
          onDelete: () {
            controller.fotoJenazah = null;
            controller.update();
          },
          onTapCamera: () async {
            await PermissionService.to.cameraRequest().then((value) {
              if (value == true) {
                controller.getFotoJenazah(ImageSource.camera);
              }
            });
            Get.back();
          },
          onTapGalery: () async {
            await PermissionService.to.storageRequest().then((value) {
              if (value == true) {
                controller.getFotoJenazah(ImageSource.gallery);
              }
            });
            Get.back();
          },
        );
      },
    );
  }
}

class InputFotoPaspor extends GetView<CreateImigranController> {
  const InputFotoPaspor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateImigranController>(
      builder: (controller) {
        return ImagePickerWidget(
          title: "Foto Paspor",
          imageFile: controller.fotoPaspor,
          onDelete: () {
            controller.fotoPaspor = null;
            controller.update();
          },
          onTapCamera: () async {
            await PermissionService.to.cameraRequest().then((value) {
              if (value == true) {
                controller.getFotoPaspor(ImageSource.camera);
              }
            });
            Get.back();
          },
          onTapGalery: () async {
            await PermissionService.to.storageRequest().then((value) {
              if (value == true) {
                controller.getFotoPaspor(ImageSource.gallery);
              }
            });
            Get.back();
          },
        );
      },
    );
  }
}

class InputFotoBrafaks extends GetView<CreateImigranController> {
  const InputFotoBrafaks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateImigranController>(
      builder: (controller) {
        return ImagePickerWidget(
          title: "Foto Brafaks",
          imageFile: controller.fotoBrafaks,
          onDelete: () {
            controller.fotoBrafaks = null;
            controller.update();
          },
          onTapCamera: () async {
            await PermissionService.to.cameraRequest().then((value) {
              if (value == true) {
                controller.getFotoBrafaks(ImageSource.camera);
              }
            });
            Get.back();
          },
          onTapGalery: () async {
            await PermissionService.to.storageRequest().then((value) {
              if (value == true) {
                controller.getFotoBrafaks(ImageSource.gallery);
              }
            });
            Get.back();
          },
        );
      },
    );
  }
}
