import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/storage_service.dart';

class IntroductionMiddleware extends GetMiddleware {
  // IntroductionMiddleware({priority}) : super(priority: priority);
  IntroductionMiddleware({super.priority});

  final StorageService storage = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    return storage.read('introduction') == false ||
            storage.read('introduction') == null
        ? const RouteSettings(name: Routes.introduction)
        : null;
  }
}
