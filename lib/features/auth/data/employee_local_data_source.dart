import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

abstract class EmployeeLocalDataSource {
  User? get user;
  String? get firebaseToken;
  String? get tokenExpiryTime;

  setTokenExpiryTime(String time);
  Future<void> saveUser({required User? u});
  set saveFirebaseToken(String? token);
  Future<void> signOut();
}

class EmployeeLocalDataSourceImpl extends EmployeeLocalDataSource {
  final SharedPreferences pref;
  EmployeeLocalDataSourceImpl({required this.pref});
  User? _user;
  String? _firebaseToken;

  @override
  User? get user {
    String usr = pref.getString('user') ?? '';

    if (usr.isEmpty) {
      return _user;
    }
    _user ??= User.fromJson(jsonDecode(usr));
    return _user;
  }

  @override
  Future<void> signOut() async {
    await pref.remove('account');
    await pref.remove('tokenExpiryTime');
    // await Hive.box('firebase').delete('firebaseOptions');
    _user = null;
  }

  @override
  String? get firebaseToken => _firebaseToken;

  @override
  set saveFirebaseToken(String? token) {
    _firebaseToken = token;
  }

  @override
  Future<void> saveUser({required User? u}) async {
    _user = u;

    await pref.setString('user', _user?.toJson() ?? '');
  }

  @override
  setTokenExpiryTime(String time) async {
    await pref.setString('tokenExpiryTime', time);
  }

  @override
  String? get tokenExpiryTime {
    return pref.getString('tokenExpiryTime');
  }
}
