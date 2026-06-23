import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import '../constants/crypto_constants.dart';
import '../exceptions/crypto_exceptions.dart';
import '../models/encrypted_payload.dart';
import '../services/secure_storage_service.dart';
import '../utils/helper_functions.dart';

class CryptoService {
  final SecureStorageService _secureStorageService =
  SecureStorageService();

  //----------------------------------------
  // SALT GENERATION
  //----------------------------------------

  Uint8List generateSalt() {
    return HelperFunctions.randomBytes(
      CryptoConstants.saltLength,
    );
  }

  //----------------------------------------
  // PASSWORD-ONLY KEY DERIVATION
  //----------------------------------------

  Future<Uint8List> derivePasswordKey({
    required String password,
    required Uint8List salt,
  }) async {
    try {
      final argon2 = Argon2id(
        memory: CryptoConstants.argonMemory,
        iterations: CryptoConstants.argonIterations,
        parallelism: CryptoConstants.argonParallelism,
        hashLength: CryptoConstants.keyLength,
      );

      final secretKey = await argon2.deriveKeyFromPassword(
        password: password,
        nonce: salt,
      );

      final bytes = await secretKey.extractBytes();

      return Uint8List.fromList(bytes);
    } catch (e) {
      throw KeyDerivationException(
        'Password-only key derivation failed: $e',
      );
    }
  }

  //----------------------------------------
  // HYBRID KEY DERIVATION
  //----------------------------------------

  Future<Uint8List> deriveHybridKey({
    required String password,
    required Uint8List salt,
  }) async {
    try {
      final pdk = await derivePasswordKey(
        password: password,
        salt: salt,
      );

      final dbs =
      await _secureStorageService.getOrCreateDeviceSecret();

      if (pdk.length != dbs.length) {
        throw KeyDerivationException(
          'PDK and DBS length mismatch.',
        );
      }

      return HelperFunctions.xor(
        pdk,
        dbs,
      );
    } catch (e) {
      throw KeyDerivationException(
        'Hybrid key derivation failed: $e',
      );
    }
  }

  //----------------------------------------
  // AES-256-GCM ENCRYPTION
  //----------------------------------------

  Future<EncryptedPayload> encrypt({
    required Uint8List key,
    required String plaintext,
  }) async {
    try {
      final algorithm = AesGcm.with256bits();

      final secretBox = await algorithm.encrypt(
        utf8.encode(plaintext),
        secretKey: SecretKey(key),
      );

      return EncryptedPayload(
        ciphertext: base64Encode(secretBox.cipherText),
        nonce: base64Encode(secretBox.nonce),
        mac: base64Encode(secretBox.mac.bytes),
      );
    } catch (e) {
      throw EncryptionException(
        'Encryption failed: $e',
      );
    }
  }

  //----------------------------------------
  // AES-256-GCM DECRYPTION
  //----------------------------------------

  Future<String> decrypt({
    required Uint8List key,
    required EncryptedPayload payload,
  }) async {
    try {
      final algorithm = AesGcm.with256bits();

      final secretBox = SecretBox(
        base64Decode(payload.ciphertext),
        nonce: base64Decode(payload.nonce),
        mac: Mac(
          base64Decode(payload.mac),
        ),
      );

      final decrypted = await algorithm.decrypt(
        secretBox,
        secretKey: SecretKey(key),
      );

      return utf8.decode(decrypted);
    } catch (e) {
      throw DecryptionException(
        'Decryption failed: $e',
      );
    }
  }

  //----------------------------------------
  // ZEROIZE MEMORY
  //----------------------------------------

  void clearKey(Uint8List key) {
    key.fillRange(0, key.length, 0);
  }
}