import 'package:hive/hive.dart';

mixin TokenStorage {
  static const _boxName = 'authBox';
  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';

  Future<void> saveAccessToken(String accessToken) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_accessTokenKey, accessToken);
  }

  Future<String?> getAccessToken() async {
    final box = await Hive.openBox(_boxName);
    return box.get(_accessTokenKey) as String?;
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_refreshTokenKey, refreshToken);
  }

  Future<String?> getRefreshToken() async {
    final box = await Hive.openBox(_boxName);
    return box.get(_refreshTokenKey) as String?;
  }

  Future<void> clearAllTokens() async {
    final box = await Hive.openBox(_boxName);
    await box.delete(_accessTokenKey);
    await box.delete(_refreshTokenKey);
  }
}