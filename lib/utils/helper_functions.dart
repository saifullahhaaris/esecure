import 'dart:math';
import 'dart:typed_data';

class HelperFunctions {
  /// Generate secure random bytes
  static Uint8List randomBytes(int length) {
    final random = Random.secure();

    return Uint8List.fromList(
      List.generate(
        length,
            (_) => random.nextInt(256),
      ),
    );
  }

  /// XOR two byte arrays
  static Uint8List xor(Uint8List a, Uint8List b) {
    if (a.length != b.length) {
      throw Exception('Byte arrays must have equal length');
    }

    final result = Uint8List(a.length);

    for (int i = 0; i < a.length; i++) {
      result[i] = a[i] ^ b[i];
    }

    return result;
  }

  /// Calculate standard deviation
  static double standardDeviation(List<int> values) {
    if (values.isEmpty) return 0;

    final mean =
        values.reduce((a, b) => a + b) / values.length;

    final variance = values
        .map((x) => pow(x - mean, 2))
        .reduce((a, b) => a + b) /
        values.length;

    return sqrt(variance);
  }
}