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
      await _crypto.derivePasswordOnlyKey(
        password: passwordController.text,
        salt: salt,
      );

      EncryptedPayload payload =
      await _crypto.encryptData(
        key: key,
        plaintext: messageController.text,
      );

      final result =
      await _crypto.decryptData(
        key: key,
        payload: payload,
      );

      append("PASSWORD-ONLY SUCCESS");
      append(result);

      key.fillRange(0, key.length, 0);
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
      await _crypto.encryptData(
        key: key,
        plaintext: messageController.text,
      );

      final result =
      await _crypto.decryptData(
        key: key,
        payload: payload,
      );

      append("HYBRID SUCCESS");
      append(result);

      key.fillRange(0, key.length, 0);
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
      passwordController.text,
    );

    append(
        "Password Average = ${result.averagePasswordOnlyMs.toStringAsFixed(2)} ms");

    append(
        "Hybrid Average = ${result.averageHybridMs.toStringAsFixed(2)} ms");

    append(
        "Fastest Password = ${result.fastestPasswordOnly} ms");

    append(
        "Slowest Password = ${result.slowestPasswordOnly} ms");

    append(
        "Fastest Hybrid = ${result.fastestHybrid} ms");

    append(
        "Slowest Hybrid = ${result.slowestHybrid} ms");

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
