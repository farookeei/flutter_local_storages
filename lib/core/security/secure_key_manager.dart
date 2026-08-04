import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureKeyManager {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _keyName = 'db_passphrase_v1';

  /// Fetches existing database passphrase or generates a cryptographically secure 256-bit key
  static Future<String> getOrCreatePassphrase() async {
    final existingKey = await _storage.read(key: _keyName);
    if (existingKey != null) {
      return existingKey;
    }

    // Generate 32 secure random bytes (256-bit key)
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    final newKey = base64Url.encode(values);

    await _storage.write(key: _keyName, value: newKey);
    return newKey;
  }
}
