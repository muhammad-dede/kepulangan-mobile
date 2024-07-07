import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/theme_service.dart';

import '../controllers/pengaturan_controller.dart';

class PengaturanView extends GetView<PengaturanController> {
  const PengaturanView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text("Pengaturan"),
          actions: [
            IconButton(
              icon: Icon(
                ThemeService.to.isDarkMode.isTrue
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
              onPressed: () async {
                await ThemeService.to.changeThemeMode();
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            const Profil(),
            const PihakKedua(),
            const Alamat(),
            const PenyediaJasa(),
            if (AuthService.to.isAdmin.isTrue) const Pengguna(),
            const Keamanan(),
            const Logout(),
          ],
        ),
      ),
    );
  }
}

class Profil extends GetView<PengaturanController> {
  const Profil({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.5),
                ),
              ),
              child: CachedNetworkImage(
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
          const SizedBox(height: 10),
          Text(
            AuthService.to.auth.value.nama ?? "",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            AuthService.to.auth.value.email ?? "",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              child: const Text("Lihat Profil Saya"),
              onPressed: () {
                Get.toNamed(Routes.profil);
              },
            ),
          ),
          const SizedBox(height: 5),
          const Divider(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class PihakKedua extends GetView<PengaturanController> {
  const PihakKedua({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.grey.withOpacity(0.1),
          child: const Icon(
            IconlyBold.user_2,
            color: Colors.grey,
          ),
        ),
        title: const Text('Pihak Kedua'),
        subtitle: const Text('Pengaturan Pihak Kedua'),
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Colors.grey,
          ),
        ),
        onTap: () {
          Get.toNamed(Routes.pihakKedua);
        },
      ),
    );
  }
}

class Alamat extends GetView<PengaturanController> {
  const Alamat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.amber.withOpacity(0.1),
          child: const Icon(
            IconlyBold.send,
            color: Colors.amber,
          ),
        ),
        title: const Text('Alamat'),
        subtitle: const Text('Pengaturan Alamat'),
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Colors.grey,
          ),
        ),
        onTap: () {
          Get.toNamed(Routes.alamat);
        },
      ),
    );
  }
}

class PenyediaJasa extends GetView<PengaturanController> {
  const PenyediaJasa({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.purple.withOpacity(0.1),
          child: const Icon(
            IconlyBold.bookmark,
            color: Colors.purple,
          ),
        ),
        title: const Text('Penyedia Jasa'),
        subtitle: const Text('Pengaturan Penyedia Jasa'),
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Colors.grey,
          ),
        ),
        onTap: () {
          Get.toNamed(Routes.penyediaJasa);
        },
      ),
    );
  }
}

class Pengguna extends GetView<PengaturanController> {
  const Pengguna({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: const Icon(
            IconlyBold.user_3,
            color: Colors.blue,
          ),
        ),
        title: const Text('Pengguna'),
        subtitle: const Text('Manajemen Pengguna'),
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Colors.grey,
          ),
        ),
        onTap: () {
          Get.toNamed(Routes.pengguna);
        },
      ),
    );
  }
}

class Keamanan extends GetView<PengaturanController> {
  const Keamanan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.green.withOpacity(0.1),
          child: const Icon(
            IconlyBold.lock,
            color: Colors.green,
          ),
        ),
        title: const Text('Keamanan'),
        subtitle: const Text('Pengaturan Keamanan Akun'),
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Colors.grey,
          ),
        ),
        onTap: () {
          Get.toNamed(Routes.keamanan);
        },
      ),
    );
  }
}

class Logout extends GetView<PengaturanController> {
  const Logout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.red.withOpacity(0.1),
          child: const Icon(
            IconlyBold.logout,
            color: Colors.red,
          ),
        ),
        title: const Text('Logout'),
        subtitle: const Text('keluar dari Aplikasi'),
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Colors.grey,
          ),
        ),
        onTap: () {
          Get.dialog(
            AlertDialog(
              title: const Text('Logout'),
              content: const Text('Apa anda yakin untuk keluar?'),
              actions: [
                TextButton(
                  child: const Text('Ya'),
                  onPressed: () async {
                    Get.back();
                    await controller.logout();
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
        },
      ),
    );
  }
}
