import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';

import '../controllers/edit_pengguna_controller.dart';

class EditPenggunaView extends GetView<EditPenggunaController> {
  const EditPenggunaView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Pengguna'),
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
            NoIdentitas(),
            Jabatan(),
            Group(),
            Telepon(),
            Email(),
            Role(),
            Password(),
            PasswordConfirmation(),
          ],
        ),
      ),
    );
  }
}

class Nama extends GetView<EditPenggunaController> {
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

class NoIdentitas extends GetView<EditPenggunaController> {
  const NoIdentitas({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "No Identitas",
        readOnly: false,
        controller: controller.noIdentitasController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.isEmpty || value == '') {
            return "No. Identitas wajib diisi";
          } else {
            return null;
          }
        },
      ),
    );
  }
}

class Jabatan extends GetView<EditPenggunaController> {
  const Jabatan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Jabatan",
        readOnly: false,
        controller: controller.jabatanController,
        obscureText: false,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.isEmpty || value == '') {
            return "Jabatan wajib diisi";
          } else {
            return null;
          }
        },
      ),
    );
  }
}

class Group extends GetView<EditPenggunaController> {
  const Group({
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
            GetBuilder<EditPenggunaController>(
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
                    Expanded(
                      child: controller.isLoadingReferensi == true
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

class Telepon extends GetView<EditPenggunaController> {
  const Telepon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Telepon",
        readOnly: false,
        controller: controller.teleponController,
        obscureText: false,
        keyboardType: TextInputType.phone,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.isEmpty || value == '') {
            return "Telepon wajib diisi";
          } else {
            return null;
          }
        },
      ),
    );
  }
}

class Email extends GetView<EditPenggunaController> {
  const Email({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Email",
        readOnly: false,
        controller: controller.emailController,
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.isEmpty || value == '') {
            return "Email wajib diisi";
          } else {
            return null;
          }
        },
      ),
    );
  }
}

class Role extends GetView<EditPenggunaController> {
  const Role({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Role",
        readOnly: true,
        controller: controller.roleController,
        obscureText: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.isEmpty || value == '') {
            return "Role wajib diisi";
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
                    'Pilih Role',
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
                    itemCount: controller.listRole.length,
                    itemBuilder: (context, index) {
                      final item = controller.listRole[index];
                      return ListTile(
                        title: Text('${item ?? ""}'),
                        trailing: controller.roleController.text == item
                            ? const Icon(Icons.check)
                            : null,
                        onTap: () {
                          controller.roleController.text = item;
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

class Password extends GetView<EditPenggunaController> {
  const Password({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditPenggunaController>(
      builder: (controller) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormFieldWidget(
            labelText: "Password Baru",
            suffixIcon: IconButton(
              onPressed: () {
                controller.isHidePassword = !controller.isHidePassword;
                controller.update();
              },
              icon: Icon(
                controller.isHidePassword == true
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
            readOnly: false,
            controller: controller.passwordController,
            obscureText: controller.isHidePassword,
            keyboardType: TextInputType.text,
          ),
        );
      },
    );
  }
}

class PasswordConfirmation extends GetView<EditPenggunaController> {
  const PasswordConfirmation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditPenggunaController>(
      builder: (controller) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormFieldWidget(
            labelText: "Konfirmasi Password Baru",
            suffixIcon: IconButton(
              onPressed: () {
                controller.isHidePasswordConfirmation =
                    !controller.isHidePasswordConfirmation;
                controller.update();
              },
              icon: Icon(
                controller.isHidePasswordConfirmation == true
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
            readOnly: false,
            controller: controller.passwordConfirmationController,
            obscureText: controller.isHidePasswordConfirmation,
            keyboardType: TextInputType.text,
          ),
        );
      },
    );
  }
}
