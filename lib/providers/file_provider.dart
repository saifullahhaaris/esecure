import 'dart:io';

import 'package:flutter/material.dart';

import '../models/file_model.dart';
import '../services/local_storage_service.dart';

class FileProvider extends ChangeNotifier {

  final LocalStorageService _storageService =
    LocalStorageService();

  List<FileModel> files = [];

  Future<void> loadFiles() async {

    final entities =
      await _storageService.getEncryptedFiles();

    files = entities
        .whereType<File>()
        .map(
          (file) => FileModel(
        fileName: file.path.split('/').last,
        path: file.path,
        createdAt: file.lastModifiedSync(),
        size: file.lengthSync(),
      ),
    )
        .toList();

    notifyListeners();
  }
}
