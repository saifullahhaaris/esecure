class CryptoConstants {
  static const int keyLength = 32;
  static const int saltLength = 16;

  static const int argonMemory = 19456;
  static const int argonIterations = 2;
  static const int argonParallelism = 1;

  static const String deviceSecretKey = 'device_bound_secret';
}
