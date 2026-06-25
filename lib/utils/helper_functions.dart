import 'dart:math';

class HelperFunctions {
  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";

    const suffixes = [
      "B",
      "KB",
      "MB",
      "GB",
      "TB"
    ];

    int i = (log(bytes) / log(1024)).floor();

    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  static String formatDate(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }
}







