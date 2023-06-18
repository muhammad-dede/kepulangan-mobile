import 'dart:io';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService extends GetxService {
  static PermissionService get to => Get.find();

  Future<PermissionService> init() async {
    await permissionRequest();
    return this;
  }

  Future<void> permissionRequest() async {
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.camera,
      ].request();

      if (statuses[Permission.storage] != PermissionStatus.granted ||
          statuses[Permission.storage]!.isDenied) {
        await Permission.storage.request();
      }
      if (statuses[Permission.camera] != PermissionStatus.granted ||
          statuses[Permission.camera]!.isDenied) {
        await Permission.camera.request();
      }
    }
  }
}
