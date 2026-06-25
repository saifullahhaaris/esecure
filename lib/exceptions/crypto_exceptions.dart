class CryptoException implements Exception {
  final String message;

  CryptoException(this.message);

  @override
  String toString() {
    return "CryptoException: $message";
  }
}

class KeyDerivationException extends CryptoException {
  KeyDerivationException(String message) : super(message);
}

class EncryptionException extends CryptoException {
  EncryptionException(String message) : super(message);
}

class DecryptionException extends CryptoException {
  DecryptionException(String message) : super(message);
}

class SecureStorageException extends CryptoException {
  SecureStorageException(String message) : super(message);
}





