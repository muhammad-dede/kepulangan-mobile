import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService extends GetxService {
  static PermissionService get to => Get.find();

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<PermissionService> init() async {
    await permissionRequest();
    return this;
  }

  Future<void> permissionRequest() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt < 33) {
        var storageStatus = await Permission.storage.status;
        if (storageStatus.isDenied ||
            storageStatus != PermissionStatus.granted ||
            storageStatus.isPermanentlyDenied) {
          await Permission.storage.request();
        }
      } else {
        var photosStatus = await Permission.photos.status;
        if (photosStatus.isDenied ||
            photosStatus != PermissionStatus.granted ||
            photosStatus.isPermanentlyDenied) {
          await Permission.photos.request();
        }

        var notificationStatus = await Permission.notification.status;
        if (notificationStatus.isDenied ||
            notificationStatus != PermissionStatus.granted ||
            notificationStatus.isPermanentlyDenied) {
          await Permission.notification.request();
        }
      }

      var cameraStatus = await Permission.camera.status;
      if (cameraStatus.isDenied ||
          cameraStatus != PermissionStatus.granted ||
          cameraStatus.isPermanentlyDenied) {
        await Permission.camera.request();
      }
    }
  }

  Future<bool> storageRequest() async {
    bool? isGranted;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt < 33) {
        var storageStatus = await Permission.storage.status;
        if (storageStatus.isDenied ||
            storageStatus != PermissionStatus.granted ||
            storageStatus.isPermanentlyDenied) {
          if (await Permission.storage.request().isGranted) {
            isGranted = true;
          } else {
            isGranted = false;
            openAppSettings();
          }
        } else {
          isGranted = true;
        }
      } else {
        var photosStatus = await Permission.photos.status;
        if (photosStatus.isDenied ||
            photosStatus != PermissionStatus.granted ||
            photosStatus.isPermanentlyDenied) {
          if (await Permission.photos.request().isGranted) {
            isGranted = true;
          } else {
            isGranted = false;
            openAppSettings();
          }
        } else {
          isGranted = true;
        }
      }
    } else {
      isGranted = true;
    }

    return isGranted;
  }

  Future<bool> cameraRequest() async {
    bool? isGranted;

    if (Platform.isAndroid) {
      var cameraStatus = await Permission.camera.status;
      if (cameraStatus.isDenied ||
          cameraStatus != PermissionStatus.granted ||
          cameraStatus.isPermanentlyDenied) {
        if (await Permission.camera.request().isGranted) {
          isGranted = true;
        } else {
          isGranted = false;
          openAppSettings();
        }
      } else {
        isGranted = true;
      }
    } else {
      isGranted = true;
    }

    return isGranted;
  }
}
