import 'package:flutter/foundation.dart';
import 'package:mapalus_partner/data/models/delivery_modifiers.dart';
import 'package:mapalus_partner/data/models/users_info.dart';
import 'package:mapalus_partner/data/models/version.dart';
import 'package:mapalus_partner/data/services/firebase_services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:developer' as dev;

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
      print('[APP VERSION] local $localVersion remote $remoteVersion');
    }

    if (remoteVersion > localVersion) {
      return false;
    }
    return true;
  }

  Future<String> getCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return 'v${packageInfo.version}';
  }

  Future<DeliveryModifiers> getDeliveryModifiers() async {
    final result = await firestoreService.getDeliveryModifiers();
    final res = result as Map<String, dynamic>;
    return DeliveryModifiers.fromMap(res);
  }

  Future<void> setDeliveryModifiers(DeliveryModifiers data) async {
    await firestoreService.setDeliveryModifiers(data.toMap);
  }

  Future<UsersInfo> getUsersInfo() async {
    final result = await firestoreService.getUsersInfo();
    final res = result as Map<String, dynamic>;
    return UsersInfo.fromMap(res);
  }

  Future<UsersInfo> queryUsersInfo(String dateTimeString) async {
    final result = await firestoreService.queryUsersInfo(dateTimeString);
    final res = result as Map<String, dynamic>;
    return UsersInfo.fromMap(res);
  }
}
