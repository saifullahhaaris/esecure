import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/crypto_constants.dart';
import '../exceptions/crypto_exceptions.dart';
import '../utils/helper_functions.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Returns existing device secret or creates one if it doesn't exist.
  Future<Uint8List> getOrCreateDeviceSecret() async {
    try {
      final existing =
      await _storage.read(key: CryptoConstants.deviceSecretKey);

      if (existing != null) {
        return base64Decode(existing);
      }

      final newSecret =
      HelperFunctions.randomBytes(CryptoConstants.keyLength);

      await _storage.write(
        key: CryptoConstants.deviceSecretKey,
        value: base64Encode(newSecret),
      );

      return newSecret;
    } catch (e) {
      throw SecureStorageException(
        'Failed to retrieve or create device secret: $e',
      );
    }
  }

  /// Returns device secret if it exists.
  Future<Uint8List?> getDeviceSecret() async {
    try {
      final existing =
      await _storage.read(key: CryptoConstants.deviceSecretKey);

      if (existing == null) {
        return null;
      }

      return base64Decode(existing);
    } catch (e) {
      throw SecureStorageException(
        'Failed to retrieve device secret: $e',
      );
    }
  }

  /// Deletes the device secret.
  Future<void> deleteDeviceSecret() async {
    try {
      await _storage.delete(
        key: CryptoConstants.deviceSecretKey,
      );
    } catch (e) {
      throw SecureStorageException(
        'Failed to delete device secret: $e',
      );
    }
  }

  /// Checks if device secret exists.
  Future<bool> deviceSecretExists() async {
    try {
      final secret =
      await _storage.read(key: CryptoConstants.deviceSecretKey);

      return secret != null;
    } catch (e) {
      throw SecureStorageException(
        'Failed to check device secret existence: $e',
      );
    }
  }
}
