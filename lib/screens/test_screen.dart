import 'package:flutter/material.dart';

import '../models/encrypted_payload.dart';
import '../models/benchmark_result.dart';
import '../services/benchmark_service.dart';
import '../services/crypto_service.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final _crypto = CryptoService();
  final _benchmark = BenchmarkService();

  final passwordController =
  TextEditingController(
    text: "TestPassword123",
  );

  final messageController =
  TextEditingController(
    text: "Hello ESecure!",
  );

  String log = "";

  bool loading = false;

  void append(String text) {
    setState(() {
      log += "\n$text";
    });
  }

  Future<void> runPasswordOnly() async {
    setState(() {
      loading = true;
      log = "";
    });

    try {
      final salt = _crypto.generateSalt();

      final key =
      await _crypto.derivePasswordKey(
        password: passwordController.text,
        salt: salt,
      );

      EncryptedPayload payload =
      await _crypto.encrypt(
        key: key,
        plaintext: messageController.text,
      );

      final result =
      await _crypto.decrypt(
        key: key,
        payload: payload,
      );

      append("PASSWORD-ONLY SUCCESS");
      append(result);

      _crypto.clearKey(key);
    } catch (e) {
      append(e.toString());
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> runHybrid() async {
    setState(() {
      loading = true;
      log = "";
    });

    try {
      final salt = _crypto.generateSalt();

      final key =
      await _crypto.deriveHybridKey(
        password: passwordController.text,
        salt: salt,
      );

      EncryptedPayload payload =
      await _crypto.encrypt(
        key: key,
        plaintext: messageController.text,
      );

      final result =
      await _crypto.decrypt(
        key: key,
        payload: payload,
      );

      append("HYBRID SUCCESS");
      append(result);

      _crypto.clearKey(key);
    } catch (e) {
      append(e.toString());
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> runBenchmark() async {
    setState(() {
      loading = true;
      log = "";
    });

    BenchmarkResult result =
    await _benchmark.runBenchmark(
      password: passwordController.text,
    );

    append(
        "Password Average = ${result.passwordOnlyAverageMs.toStringAsFixed(2)} ms");

    append(
        "Hybrid Average = ${result.hybridAverageMs.toStringAsFixed(2)} ms");

    append(
        "Password StdDev = ${result.passwordOnlyStdDev.toStringAsFixed(2)}");

    append(
        "Hybrid StdDev = ${result.hybridStdDev.toStringAsFixed(2)}");

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ESecure Test Harness",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              decoration:
              const InputDecoration(
                labelText: "Password",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: messageController,
              decoration:
              const InputDecoration(
                labelText: "Message",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed:
              loading ? null : runPasswordOnly,
              child: const Text(
                "Password Only",
              ),
            ),
            ElevatedButton(
              onPressed:
              loading ? null : runHybrid,
              child: const Text(
                "Hybrid",
              ),
            ),
            ElevatedButton(
              onPressed:
              loading ? null : runBenchmark,
              child: const Text(
                "Benchmark",
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  log,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
