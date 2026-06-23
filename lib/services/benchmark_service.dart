import '../constants/crypto_constants.dart';
import '../models/benchmark_result.dart';
import '../services/crypto_service.dart';
import '../utils/helper_functions.dart';

class BenchmarkService {
  final CryptoService _cryptoService = CryptoService();

  Future<BenchmarkResult> runBenchmark({
    required String password,
  }) async {
    final List<int> passwordOnlyTimes = [];
    final List<int> hybridTimes = [];

    // Warm-up runs
    for (int i = 0; i < CryptoConstants.warmupRuns; i++) {
      final salt = _cryptoService.generateSalt();

      await _cryptoService.derivePasswordKey(
        password: password,
        salt: salt,
      );

      await _cryptoService.deriveHybridKey(
        password: password,
        salt: salt,
      );
    }

    // Benchmark runs
    for (int i = 0; i < CryptoConstants.benchmarkIterations; i++) {
      final salt = _cryptoService.generateSalt();

      final sw1 = Stopwatch()..start();

      await _cryptoService.derivePasswordKey(
        password: password,
        salt: salt,
      );

      sw1.stop();

      final sw2 = Stopwatch()..start();

      await _cryptoService.deriveHybridKey(
        password: password,
        salt: salt,
      );

      sw2.stop();

      passwordOnlyTimes.add(
        sw1.elapsedMilliseconds,
      );

      hybridTimes.add(
        sw2.elapsedMilliseconds,
      );
    }

    final passwordMean =
        passwordOnlyTimes.reduce((a, b) => a + b) /
            passwordOnlyTimes.length;

    final hybridMean =
        hybridTimes.reduce((a, b) => a + b) /
            hybridTimes.length;

    return BenchmarkResult(
      passwordOnlyAverageMs: passwordMean,
      hybridAverageMs: hybridMean,
      passwordOnlyStdDev:
      HelperFunctions.standardDeviation(
        passwordOnlyTimes,
      ),
      hybridStdDev:
      HelperFunctions.standardDeviation(
        hybridTimes,
      ),
    );
  }
}
