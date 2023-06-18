import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/services/permission_service.dart';
import 'package:kepulangan/app/services/storage_service.dart';
import 'package:path_provider/path_provider.dart';

class PdfController extends GetxController {
  String? title = Get.arguments["title"];
  String? streamUrl = Get.arguments['stream_url'];
  String? downloadUrl = Get.arguments['download_url'];

  ReceivePort receivePort = ReceivePort();

  @override
  void onInit() {
    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, 'downloader_send_port');
    receivePort.listen((dynamic data) {
      DownloadTaskStatus status = DownloadTaskStatus(data[1]);

      if (status == DownloadTaskStatus.complete) {
        EasyLoading.showSuccess("Berhasil mengunduh");
      }
      if (status == DownloadTaskStatus.failed) {
        EasyLoading.showError("Gagal mengunduh");
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
    super.onInit();
  }

  @override
  void onClose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.onClose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  Future<void> download() async {
    PermissionService.to.storageRequest().then((value) async {
      if (value == true) {
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
    });
  }
}
