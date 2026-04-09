import 'package:hive/hive.dart';

mixin TokenStorage {
  Future<void> saveAccessToken(String accessToken) async {
    var box = await Hive.openBox('authBox');
    await box.put('accessToken', accessToken);
  }

  Future<String?> getAccessToken() async {
    var box = await Hive.openBox('authBox');
    return box.get('accessToken');
  }

  Future<void> clearTokens() async {
    var box = await Hive.openBox('authBox');
    await box.delete('accessToken');
  }
}