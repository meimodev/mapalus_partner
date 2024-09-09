import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_partner/shared/routes.dart';

import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await HiveService().init();

  await Jiffy.setLocale("id");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, _) => GetMaterialApp(
        title: 'Mapalus Partner',
        theme: appThemeData,
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.home,
        getPages: Routes.getRoutes(),


      ),
    );
  }
}
