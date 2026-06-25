import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorageService {

  Future<Directory> getEncryptedFilesDirectory() async {

    final appDir = await getApplicationDocumentsDirectory();

    final encryptedDir = Directory(
      "${appDir.path}/encrypted_files",
    );

    if (!await encryptedDir.exists()) {
      await encryptedDir.create(
        recursive: true,
      );
    }

    return encryptedDir;
  }

  Future<File> saveEncryptedFile({
    required String fileName,
    required String encryptedContent,
  }) async {

    final directory =
    await getEncryptedFilesDirectory();

    final file = File(
      "${directory.path}/$fileName.enc",
    );

    return await file.writeAsString(
      encryptedContent,
    );
  }

  Future<List<FileSystemEntity>> getEncryptedFiles() async {

    final directory =
    await getEncryptedFilesDirectory();

    return directory.listSync();
  }

  Future<void> deleteFile(
      String path,
      ) async {

    final file = File(path);

    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<File> exportDecryptedFile({
    required String fileName,
    required List<int> bytes,
  }) async {

    final appDir =
    await getApplicationDocumentsDirectory();

    final exportDir = Directory(
      "${appDir.path}/exported_files",
    );

    if (!await exportDir.exists()) {
      await exportDir.create(
        recursive: true,
      );
    }

    final file = File(
      "${exportDir.path}/$fileName",
    );

    return await file.writeAsBytes(
      bytes,
    );
  }
}