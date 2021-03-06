import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapalus_partner/shared/routes.dart';
import 'package:mapalus_partner/shared/theme.dart';
import 'package:jiffy/jiffy.dart';

import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("This is a background message: ${message.messageId}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  await Jiffy.locale("id");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
      builder: (_) => GetMaterialApp(
        title: 'Mapalus Partner',
        theme: appThemeData,
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.splash,
        getPages: Routes.getRoutes(),
        builder: (context, widget) {
          ScreenUtil.setContext(context);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0,
            ),
            child: widget!,
          );
        },
      ),
    );
  }
}