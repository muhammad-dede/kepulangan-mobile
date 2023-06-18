import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kepulangan/app/routes/app_pages.dart';
import 'package:kepulangan/app/services/storage_service.dart';

class AuthMiddleware extends GetMiddleware {
  AuthMiddleware({priority}) : super(priority: priority);

  final StorageService storage = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    return storage.read('token') == false || storage.read('token') == null
        ? const RouteSettings(name: Routes.login)
        : null;
  }
}
