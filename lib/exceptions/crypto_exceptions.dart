class KeyDerivationException implements Exception {
  final String message;

  KeyDerivationException(this.message);

  @override
  String toString() => 'KeyDerivationException: $message';
}

class EncryptionException implements Exception {
  final String message;

  EncryptionException(this.message);

  @override
  String toString() => 'EncryptionException: $message';
}

class DecryptionException implements Exception {
  final String message;

  DecryptionException(this.message);

  @override
  String toString() => 'DecryptionException: $message';
}

class SecureStorageException implements Exception {
  final String message;

  SecureStorageException(this.message);

  @override
  String toString() => 'SecureStorageException: $message';
}