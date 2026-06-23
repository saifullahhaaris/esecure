class BenchmarkResult {
  final double passwordOnlyAverageMs;
  final double hybridAverageMs;

  final double passwordOnlyStdDev;
  final double hybridStdDev;

  const BenchmarkResult({
    required this.passwordOnlyAverageMs,
    required this.hybridAverageMs,
    required this.passwordOnlyStdDev,
    required this.hybridStdDev,
  });
}
