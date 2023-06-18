import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/permission_service.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';

import '../controllers/profil_controller.dart';

class ProfilView extends GetView<ProfilController> {
  const ProfilView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
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
            Avatar(),
            Nama(),
            NoIdentitas(),
            Jabatan(),
            Telepon(),
            Email(),
            Group(),
          ],
        ),
      ),
    );
  }
}

class Avatar extends GetView<ProfilController> {
  const Avatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfilController>(
      builder: (controller) {
        return Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5),
                      ),
                    ),
                    child: controller.avatar != null
                        ? Image.file(
                            controller.avatar!,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            key: UniqueKey(),
                            fit: BoxFit.cover,
                            imageUrl: AuthService.to.auth.value.avatar ?? "",
                            placeholder: (context, url) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return const Icon(
                                Icons.image,
                                size: 75,
                              );
                            },
                            cacheManager: CacheManager(
                              Config(
                                "avatar",
                                stalePeriod: const Duration(days: 3),
                              ),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Icon(
                        Icons.camera_enhance,
                        size: 20,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    onTap: () {
                      Get.bottomSheet(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                        Wrap(
                          children: [
                            ListTile(
                              title: const Text(
                                'Pilih Avatar',
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
                              leading: const Icon(Icons.camera_enhance),
                              title: const Text('Kamera'),
                              onTap: () async {
                                await PermissionService.to
                                    .cameraRequest()
                                    .then((value) {
                                  if (value == true) {
                                    controller.getAvatar(ImageSource.camera);
                                  }
                                });
                                Get.back();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text('Galeri'),
                              onTap: () async {
                                await PermissionService.to
                                    .storageRequest()
                                    .then((value) {
                                  if (value == true) {
                                    controller.getAvatar(ImageSource.gallery);
                                  }
                                });
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            const Divider(height: 30),
          ],
        );
      },
    );
  }
}

class Nama extends GetView<ProfilController> {
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
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class NoIdentitas extends GetView<ProfilController> {
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
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class Jabatan extends GetView<ProfilController> {
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
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class Telepon extends GetView<ProfilController> {
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
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class Email extends GetView<ProfilController> {
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
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class Group extends GetView<ProfilController> {
  const Group({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Group",
        enabled: AuthService.to.isAdmin.value,
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
            GetBuilder<ProfilController>(
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
