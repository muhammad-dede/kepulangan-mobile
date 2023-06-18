import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/group.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/base_client.dart';
import 'package:kepulangan/app/services/storage_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class LaporanController extends GetxController {
  final formState = GlobalKey<FormState>();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final jenisLaporanController = TextEditingController();
  final groupController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;
  int? jenisLaporan;
  String? url;
  int? idGroup;

  List<Map<String, dynamic>> listJenisLaporan = [
    {
      "label": "Laporan Harian",
      "value": 0,
      "url": "${BaseClient.apiUrl}/api/pdf/laporan-imigran",
    },
    {
      "label": "Laporan Bulanan",
      "value": 1,
      "url": "${BaseClient.apiUrl}/api/excel/laporan-bulanan",
    },
  ];

  List<Group>? listGroup;
  bool? isLoading;

  ReceivePort receivePort = ReceivePort();

  @override
  void onInit() {
    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, 'downloader_send_port');
    receivePort.listen((dynamic data) {
      DownloadTaskStatus status = DownloadTaskStatus(data[1]);

      if (status == DownloadTaskStatus.complete) {
        EasyLoading.showSuccess("Berhasil mengunduh");
        Get.back();
      }
      if (status == DownloadTaskStatus.failed) {
        EasyLoading.showError("Gagal mengunduh");
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
    super.onInit();
  }

  @override
  void onReady() {
    if (AuthService.to.isAdmin.isFalse) {
      groupController.text = AuthService.to.auth.value.nama ?? "";
      idGroup = AuthService.to.auth.value.group?.id;
    }
    super.onReady();
  }

  @override
  void onClose() {
    startDateController.dispose();
    endDateController.dispose();
    jenisLaporanController.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.onClose();
  }

  String? validator(String value) {
    if (value.isEmpty) {
      return "Bidang ini wajib diisi";
    }
    return null;
  }

  Future<void> getGroup() async {
    try {
      isLoading = true;
      final response = await BaseClient().get("/api/referensi/group");
      response.fold((l) {
        listGroup = [];
      }, (r) {
        List data = r['data'];
        listGroup = data.map((e) => Group.fromJson(e)).toList();
      });
    } finally {
      isLoading = false;
      update();
    }
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  Future<void> downloadExcel(String? downloadUrl) async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.storage.request();
      }
      if (status.isGranted) {
        try {
          final dir = await getExternalStorageDirectory();
          if (dir != null) {
            await FlutterDownloader.enqueue(
              url: downloadUrl ?? "",
              headers: {
                'Authorization': 'Bearer ${StorageService.to.read('token')}',
              },
              savedDir: dir.path,
              showNotification: true,
              openFileFromNotification: true,
              saveInPublicStorage: true,
            );
          }
        } catch (e) {
          EasyLoading.showError(e.toString());
        }
      }
    }
  }

  Future<void> save() async {
    if (formState.currentState!.validate()) {
      if (jenisLaporan == 0) {
        Get.offNamed(
          Routes.pdf,
          arguments: {
            "title": jenisLaporanController.text,
            "stream_url":
                "$url?id_group=$idGroup&start_date=$startDate&end_date=$endDate&download=false",
            "download_url":
                "$url?id_group=$idGroup&start_date=$startDate&end_date=$endDate&download=true"
          },
        );
      } else {
        try {
          EasyLoading.show(
              status: 'loading...', maskType: EasyLoadingMaskType.black);
          await downloadExcel("$url?start_date=$startDate&end_date=$endDate");
        } finally {
          EasyLoading.dismiss();
        }
      }
    }
  }
}
