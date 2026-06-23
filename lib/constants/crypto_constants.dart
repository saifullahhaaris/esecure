class CryptoConstants {
  // ---------- Secure Storage ----------

  static const String deviceSecretKey = 'device_bound_secret';

  // ---------- Sizes ----------

  static const int saltLength = 16; // 128-bit salt
  static const int keyLength = 32; // 256-bit key

  // ---------- Argon2id Parameters ----------
  // Based on OWASP recommendations

  static const int argonMemory = 19456; // ~19 MB
  static const int argonIterations = 2;
  static const int argonParallelism = 1;

  // ---------- Benchmark ----------

  static const int benchmarkIterations = 10;
  static const int warmupRuns = 1;
}