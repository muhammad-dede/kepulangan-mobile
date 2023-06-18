import 'package:flutter/material.dart';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kepulangan/app/services/auth_service.dart';
import 'package:kepulangan/app/services/permission_service.dart';
import 'package:kepulangan/app/services/storage_service.dart';
import 'package:kepulangan/app/services/theme_service.dart';

import 'app/routes/app_pages.dart';
import 'package:kepulangan/app/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Flutter Downloader
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  // DateFormat Localization
  await initializeDateFormatting('id_ID', null);
  // Service
  await Get.putAsync(() => StorageService().init(), permanent: true);
  await Get.putAsync(() => ThemeService().init(), permanent: true);
  await Get.putAsync(() => PermissionService().init(), permanent: true);
  await Get.putAsync(() => AuthService().init(), permanent: true);

  FlutterNativeSplash.remove();

  runApp(const MainApp());
}

class MainApp extends GetView {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Kepulangan",
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      themeMode: Themes().getThemeMode(),
      theme: Themes().lightTheme,
      darkTheme: Themes().darkTheme,
      builder: EasyLoading.init(),
    );
  }
}
