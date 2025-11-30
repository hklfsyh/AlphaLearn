import '../../core/core.dart';
import 'package:alphalearn/routes/app_pages.dart';
import 'package:alphalearn/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/utils/audo_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.initialize();

  final audioService = AudioService();
  await audioService.init();

  Get.put(audioService, permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      initialRoute: AppConstants.splashRoute,
      getPages: appPages,
    );
  }
}
