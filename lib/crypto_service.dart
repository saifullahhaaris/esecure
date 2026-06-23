// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:math';
// import 'package:cryptography/cryptography.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// class CryptoService {
//   final _secureStorage = const FlutterSecureStorage();
//   static const _deviceSecretKey = 'device_bound_secret';
//
//   // ---------- DEVICE-BOUND SECRET ----------
//
//   /// Retrieves the device-bound secret, generating one on first run.
//   Future<Uint8List> getOrCreateDeviceSecret() async {
//     final existing = await _secureStorage.read(key: _deviceSecretKey);
//     if (existing != null) {
//       return base64Decode(existing);
//     }
//
//     // Generate a new 256-bit random secret
//     final random = Random.secure();
//     final secretBytes = Uint8List.fromList(
//       List<int>.generate(32, (_) => random.nextInt(256)),
//     );
//
//     await _secureStorage.write(
//       key: _deviceSecretKey,
//       value: base64Encode(secretBytes),
//     );
//
//     return secretBytes;
//   }
//
//   // ---------- KEY DERIVATION ----------
//
//   /// Generates a random salt for Argon2. In production, store this
//   /// alongside the user record so the same salt is reused on login.
//   Uint8List generateSalt() {
//     final random = Random.secure();
//     return Uint8List.fromList(List<int>.generate(16, (_) => random.nextInt(256)));
//   }
//
//   /// Password-only key derivation using Argon2id.
//   Future<Uint8List> deriveKeyPasswordOnly({
//     required String password,
//     required Uint8List salt,
//   }) async {
//     final algorithm = Argon2id(
//       memory: 19456, // ~19 MB, OWASP recommended minimum
//       parallelism: 1,
//       iterations: 2,
//       hashLength: 32, // 256-bit output
//     );
//
//     final secretKey = await algorithm.deriveKeyFromPassword(
//       password: password,
//       nonce: salt,
//     );
//
//     final keyBytes = await secretKey.extractBytes();
//     return Uint8List.fromList(keyBytes);
//   }
//
//   /// Hybrid key derivation: Argon2id(password) XOR deviceSecret.
//   Future<Uint8List> deriveKeyHybrid({
//     required String password,
//     required Uint8List salt,
//   }) async {
//     final pdk = await deriveKeyPasswordOnly(password: password, salt: salt);
//     final dbs = await getOrCreateDeviceSecret();
//
//     if (pdk.length != dbs.length) {
//       throw Exception('Key length mismatch between PDK and DBS');
//     }
//
//     final masterKey = Uint8List(pdk.length);
//     for (int i = 0; i < pdk.length; i++) {
//       masterKey[i] = pdk[i] ^ dbs[i];
//     }
//
//     return masterKey;
//   }
//
//   // ---------- ENCRYPTION / DECRYPTION (AES-256-GCM) ----------
//
//   Future<Map<String, String>> encryptData({
//     required Uint8List key,
//     required String plaintext,
//   }) async {
//     final algorithm = AesGcm.with256bits();
//     final secretKey = SecretKey(key);
//
//     final secretBox = await algorithm.encrypt(
//       utf8.encode(plaintext),
//       secretKey: secretKey,
//     );
//
//     return {
//       'ciphertext': base64Encode(secretBox.cipherText),
//       'nonce': base64Encode(secretBox.nonce),
//       'mac': base64Encode(secretBox.mac.bytes),
//     };
//   }
//
//   Future<String> decryptData({
//     required Uint8List key,
//     required Map<String, String> encryptedPayload,
//   }) async {
//     final algorithm = AesGcm.with256bits();
//     final secretKey = SecretKey(key);
//
//     final secretBox = SecretBox(
//       base64Decode(encryptedPayload['ciphertext']!),
//       nonce: base64Decode(encryptedPayload['nonce']!),
//       mac: Mac(base64Decode(encryptedPayload['mac']!)),
//     );
//
//     final decrypted = await algorithm.decrypt(secretBox, secretKey: secretKey);
//     return utf8.decode(decrypted);
//   }
//
//   // ---------- PERFORMANCE MEASUREMENT ----------
//
//   /// Measures key derivation latency in milliseconds for both approaches.
//   Future<Map<String, int>> benchmarkKeyDerivation(String password) async {
//     final salt = generateSalt();
//
//     final stopwatch1 = Stopwatch()..start();
//     await deriveKeyPasswordOnly(password: password, salt: salt);
//     stopwatch1.stop();
//
//     final stopwatch2 = Stopwatch()..start();
//     await deriveKeyHybrid(password: password, salt: salt);
//     stopwatch2.stop();
//
//     return {
//       'passwordOnlyMs': stopwatch1.elapsedMilliseconds,
//       'hybridMs': stopwatch2.elapsedMilliseconds,
//     };
//   }
// }