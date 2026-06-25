class CryptoConstants {
  // Argon2id parameters
  static const int memory = 19456; // 19 MB
  static const int iterations = 2;
  static const int parallelism = 1;

  // Key settings
  static const int keyLength = 32; // 256 bits
  static const int saltLength = 16; // 128 bits

  // AES-GCM
  static const int nonceLength = 12;

  // Secure storage key
  static const String deviceSecretKey = 'device_bound_secret';

  // Benchmark
  static const int benchmarkRuns = 10;
}








