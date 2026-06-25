import 'dart:io';

import 'package:flutter/material.dart';

import '../models/file_model.dart';
import '../services/file_encryption_service.dart';
import '../services/local_storage_service.dart';

class FileViewScreen extends StatelessWidget {
  final FileModel file;

  const FileViewScreen({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    final fileEncryptionService =
    FileEncryptionService();

    final localStorageService =
    LocalStorageService();

    return Scaffold(
      appBar: AppBar(
        title: Text(file.fileName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.lock,
              size: 80,
            ),

            const SizedBox(height: 20),

            Text(
              file.fileName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              icon: const Icon(Icons.lock_open),
              label: const Text(
                "Decrypt",
              ),
              onPressed: () async {
                final controller =
                TextEditingController();

                final password =
                await showDialog<String>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text(
                      "Enter Password",
                    ),
                    content: TextField(
                      controller: controller,
                      obscureText: true,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            controller.text,
                          );
                        },
                        child: const Text(
                          "OK",
                        ),
                      ),
                    ],
                  ),
                );

                if (password == null ||
                    password.isEmpty) {
                  return;
                }

                try {
                  final exportedFile =
                  await fileEncryptionService
                      .decryptAndExportFile(
                    encryptedFile:
                    File(file.path),
                    password: password,
                  );

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        "Exported to: ${exportedFile.path}",
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        "Error: $e",
                      ),
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download),
              label: const Text(
                "Export",
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text(
                "Delete",
              ),
              onPressed: () async {
                await localStorageService
                    .deleteFile(file.path);

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}