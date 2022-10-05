import 'package:hive/hive.dart';

import 'package:mapalus_partner/data/models/user_app.dart';

abstract class UserRepoContract {
  // Future<UserApp?> readSignedInUser();
  //
  // Future<bool> checkIfRegistered(String phone);
  //
  // Future<UserApp> registerUser(String phone, String name);
  //
  // void requestOTP(String phone, Function(Result) onResult);

  Future<bool> signIn({required String phone, required String password});

  Future<UserApp?> getSignedIn();

  Future<bool> signOut();
}

class UserRepo extends UserRepoContract {
  Box<bool>? _signingBox;

  final _isSignedInKey = 'isSignedIn';
  final _boxSigningKey = 'signing';

  UserRepo() {
    _init();
  }

  _init() async {
    _signingBox = await Hive.openBox(_boxSigningKey);
  }

  @override
  Future<bool> signIn({
    required String phone,
    required String password,
  }) async {
    if (phone == "089525699078" && password == "089525699078") {
      await _signingBox!.put(_isSignedInKey, true);
      return true;
    }
    return false;
  }

  @override
  Future<bool> signOut() async {
    await _signingBox!.clear();
    return true;
  }

  @override
  Future<UserApp?> getSignedIn() async {
    final isSigned =
        _signingBox!.get(_isSignedInKey, defaultValue: false) ;

    if (isSigned!) {
      return UserApp(phone: '089525699078', name: 'Pasar');
    }
    return null;
  }
}
