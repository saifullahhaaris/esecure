import 'dart:convert';
import 'dart:io';

import '../models/encrypted_payload.dart';
import 'crypto_service.dart';
import 'local_storage_service.dart';

class FileEncryptionService {
  final CryptoService _crypto = CryptoService();
  final LocalStorageService _storage = LocalStorageService();

  Future<void> encryptAndStoreFile({
    required File file,
    required String password,
  }) async {
    final bytes = await file.readAsBytes();

    final salt = _crypto.generateSalt();

    final key = await _crypto.deriveHybridKey(
      password: password,
      salt: salt,
    );

    final payload = await _crypto.encryptFileBytes(
      key: key,
      bytes: bytes,
    );

    final jsonPayload = jsonEncode({
      "ciphertext": payload.ciphertext,
      "nonce": payload.nonce,
      "mac": payload.mac,
      "salt": base64Encode(salt),
    });

    await _storage.saveEncryptedFile(
      fileName: file.uri.pathSegments.last,
      encryptedContent: jsonPayload,
    );
  }

  Future<File> decryptAndExportFile({
    required File encryptedFile,
    required String password,
  }) async {
    final jsonString = await encryptedFile.readAsString();

    final jsonData = jsonDecode(jsonString);

    final payload = EncryptedPayload(
      ciphertext: jsonData["ciphertext"],
      nonce: jsonData["nonce"],
      mac: jsonData["mac"],
    );

    final salt = base64Decode(
      jsonData["salt"],
    );

    final key = await _crypto.deriveHybridKey(
      password: password,
      salt: salt,
    );

    final decryptedBytes = await _crypto.decryptFile(
      key: key,
      payload: payload,
    );

    final exportedFile =
    await _storage.exportDecryptedFile(
      fileName: encryptedFile.path
          .split('/')
          .last
          .replaceAll('.enc', ''),
      bytes: decryptedBytes,
    );

    return exportedFile;
  }
}