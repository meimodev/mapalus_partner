import 'package:flutter/foundation.dart';
import 'package:mapalus_partner/data/models/version.dart';
import 'package:mapalus_partner/data/services/firebase_services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppRepoContract {}

class AppRepo extends AppRepoContract {
  FirestoreService firestoreService = FirestoreService();

  Future<List<Map<String, dynamic>>> getDeliveryTimes() async {
    var data = await firestoreService.getDeliveryTimes();
    return data;
  }

  Future<bool> checkIfLatestVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;
    Version localVersion = Version.fromList(version.split('.'));

    var data = await firestoreService.getAppVersion();
    Version remoteVersion = Version.fromMap(data as Map<String, dynamic>);

    if (kDebugMode) {
      print('[APP VERSION] local $localVersion');
      print('[APP VERSION] remote $remoteVersion');
    }

    if (localVersion == remoteVersion) {
      return true;
    }
    if (localVersion.major == remoteVersion.major &&
        localVersion.minor == remoteVersion.minor) {
      return true;
    }
    return false;
  }
}