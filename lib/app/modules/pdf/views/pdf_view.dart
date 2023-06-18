import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kepulangan/app/services/storage_service.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../controllers/pdf_controller.dart';

class PdfView extends GetView<PdfController> {
  const PdfView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title ?? ""),
        actions: [
          IconButton(
            onPressed: () {
              controller.download();
            },
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: SfPdfViewer.network(
        controller.streamUrl ?? "",
        headers: {
          'Authorization': 'Bearer ${StorageService.to.read('token')}',
        },
      ),
    );
  }
}
