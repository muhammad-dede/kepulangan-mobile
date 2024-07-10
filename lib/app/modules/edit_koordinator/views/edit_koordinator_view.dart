import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kepulangan/app/modules/edit_koordinator/controllers/edit_koordinator_controller.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';

class EditKoordinatorView extends GetView<EditKoordinatorController> {
  const EditKoordinatorView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Koordinator'),
        actions: [
          TextButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              await controller.save();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
      body: Form(
        key: controller.formState,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: const [
            Nama(),
            Nip(),
            Status(),
          ],
        ),
      ),
    );
  }
}

class Nama extends GetView<EditKoordinatorController> {
  const Nama({
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
        validator: (value) {
          if (value!.isEmpty || value == '') {
            return "Nama wajib diisi";
          } else {
            return null;
          }
        },
      ),
    );
  }
}

class Nip extends GetView<EditKoordinatorController> {
  const Nip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "NIP",
        readOnly: false,
        controller: controller.nipController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.isEmpty || value == '') {
            return "NIP wajib diisi";
          } else {
            return null;
          }
        },
      ),
    );
  }
}

class Status extends GetView<EditKoordinatorController> {
  const Status({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Status",
        readOnly: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        controller: controller.statusController,
        obscureText: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.isEmpty || value == '') {
            return "Status wajib diisi";
          } else {
            return null;
          }
        },
        onTap: () {
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
                    'Pilih Status',
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
                    itemCount: controller.listStatus.length,
                    itemBuilder: (context, index) {
                      final item = controller.listStatus[index];
                      return ListTile(
                        title: Text('${item ?? ""}'),
                        trailing: controller.statusController.text == item
                            ? const Icon(Icons.check)
                            : null,
                        onTap: () {
                          controller.statusController.text = item;
                          Get.back();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
