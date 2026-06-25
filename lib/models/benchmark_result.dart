class BenchmarkResult {
  final double averagePasswordOnlyMs;
  final double averageHybridMs;

  final int fastestPasswordOnly;
  final int slowestPasswordOnly;

  final int fastestHybrid;
  final int slowestHybrid;

  BenchmarkResult({
    required this.averagePasswordOnlyMs,
    required this.averageHybridMs,
    required this.fastestPasswordOnly,
    required this.slowestPasswordOnly,
    required this.fastestHybrid,
    required this.slowestHybrid,
  });
}



