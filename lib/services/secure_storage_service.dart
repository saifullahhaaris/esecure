import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/crypto_constants.dart';
import '../exceptions/crypto_exceptions.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Uint8List> getOrCreateDeviceSecret() async {
    try {
      final existing =
          await _storage.read(key: CryptoConstants.deviceSecretKey);

      if (existing != null) {
        return base64Decode(existing);
      }

      final random = Random.secure();

      final secret = Uint8List.fromList(
        List.generate(
          CryptoConstants.keyLength,
          (_) => random.nextInt(256),
        ),
      );

      await _storage.write(
        key: CryptoConstants.deviceSecretKey,
        value: base64Encode(secret),
      );

      return secret;
    } catch (e) {
      throw SecureStorageException(
        "Failed to access secure storage: $e",
      );
    }
  }
}









