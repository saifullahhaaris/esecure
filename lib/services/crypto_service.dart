import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import '../constants/crypto_constants.dart';
import '../exceptions/crypto_exceptions.dart';
import '../models/encrypted_payload.dart';
import 'secure_storage_service.dart';

class CryptoService {
  final SecureStorageService _secureStorageService =
  SecureStorageService();

  Uint8List generateSalt() {
    final random = Random.secure();

    return Uint8List.fromList(
      List.generate(
        CryptoConstants.saltLength,
            (_) => random.nextInt(256),
      ),
    );
  }

  Future<Uint8List> derivePasswordOnlyKey({
    required String password,
    required Uint8List salt,
  }) async {
    final algorithm = Argon2id(
      memory: CryptoConstants.memory,
      iterations: CryptoConstants.iterations,
      parallelism: CryptoConstants.parallelism,
      hashLength: CryptoConstants.keyLength,
    );

    final secretKey = await algorithm.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );

    return Uint8List.fromList(
      await secretKey.extractBytes(),
    );
  }

  Future<Uint8List> deriveHybridKey({
    required String password,
    required Uint8List salt,
  }) async {
    final pdk = await derivePasswordOnlyKey(
      password: password,
      salt: salt,
    );

    final dbs =
    await _secureStorageService.getOrCreateDeviceSecret();

    final masterKey =
    Uint8List(CryptoConstants.keyLength);

    for (int i = 0; i < CryptoConstants.keyLength; i++) {
      masterKey[i] = pdk[i] ^ dbs[i];
    }

    return masterKey;
  }

  Future<EncryptedPayload> encryptData({
    required Uint8List key,
    required String plaintext,
  }) async {
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
  }

  Future<String> decryptData({
    required Uint8List key,
    required EncryptedPayload payload,
  }) async {
    final algorithm = AesGcm.with256bits();

    final secretBox = SecretBox(
      base64Decode(payload.ciphertext),
      nonce: base64Decode(payload.nonce),
      mac: Mac(base64Decode(payload.mac)),
    );

    final decrypted = await algorithm.decrypt(
      secretBox,
      secretKey: SecretKey(key),
    );

    return utf8.decode(decrypted);
  }

  Future<EncryptedPayload> encryptFileBytes({
    required Uint8List key,
    required Uint8List bytes,
  }) async {
    final algorithm = AesGcm.with256bits();

    final secretBox = await algorithm.encrypt(
      bytes,
      secretKey: SecretKey(key),
    );

    return EncryptedPayload(
      ciphertext: base64Encode(secretBox.cipherText),
      nonce: base64Encode(secretBox.nonce),
      mac: base64Encode(secretBox.mac.bytes),
    );
  }

  Future<Uint8List> decryptFile({
    required Uint8List key,
    required EncryptedPayload payload,
  }) async {
    final algorithm = AesGcm.with256bits();

    final secretBox = SecretBox(
      base64Decode(payload.ciphertext),
      nonce: base64Decode(payload.nonce),
      mac: Mac(base64Decode(payload.mac)),
    );

    final decrypted = await algorithm.decrypt(
      secretBox,
      secretKey: SecretKey(key),
    );

    return Uint8List.fromList(decrypted);
  }
}





















