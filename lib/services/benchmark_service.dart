import '../constants/crypto_constants.dart';
import '../models/benchmark_result.dart';
import 'crypto_service.dart';

class BenchmarkService {
  final CryptoService _cryptoService = CryptoService();

  Future<BenchmarkResult> runBenchmark(
    String password,
  ) async {
    final salt = _cryptoService.generateSalt();

    // Warm-up
    await _cryptoService.derivePasswordOnlyKey(
      password: password,
      salt: salt,
    );

    await _cryptoService.deriveHybridKey(
      password: password,
      salt: salt,
    );

    List<int> passwordOnlyTimes = [];
    List<int> hybridTimes = [];

    for (int i = 0; i < CryptoConstants.benchmarkRuns; i++) {
      final sw1 = Stopwatch()..start();

      await _cryptoService.derivePasswordOnlyKey(
        password: password,
        salt: salt,
      );

      sw1.stop();

      passwordOnlyTimes.add(sw1.elapsedMilliseconds);

      final sw2 = Stopwatch()..start();

      await _cryptoService.deriveHybridKey(
        password: password,
        salt: salt,
      );

      sw2.stop();

      hybridTimes.add(sw2.elapsedMilliseconds);
    }

    double avgPassword =
        passwordOnlyTimes.reduce((a, b) => a + b) /
            passwordOnlyTimes.length;

    double avgHybrid =
        hybridTimes.reduce((a, b) => a + b) /
            hybridTimes.length;

    return BenchmarkResult(
      averagePasswordOnlyMs: avgPassword,
      averageHybridMs: avgHybrid,
      fastestPasswordOnly: passwordOnlyTimes.reduce((a, b) => a < b ? a : b),
      slowestPasswordOnly: passwordOnlyTimes.reduce((a, b) => a > b ? a : b),
      fastestHybrid: hybridTimes.reduce((a, b) => a < b ? a : b),
      slowestHybrid: hybridTimes.reduce((a, b) => a > b ? a : b),
    );
  }
}









