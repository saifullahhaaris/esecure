import 'dart:io';

import 'package:flutter/material.dart';

import '../models/file_model.dart';
import '../services/local_storage_service.dart';
import '../widgets/file_tile.dart';
import 'file_view_screen.dart';

class FolderScreen extends StatefulWidget {
  final String folderName;

  const FolderScreen({
    super.key,
    required this.folderName,
  });

  @override
  State<FolderScreen> createState() =>
      _FolderScreenState();
}

class _FolderScreenState
    extends State<FolderScreen> {

  final LocalStorageService _storageService =
  LocalStorageService();

  List<FileModel> files = [];

  @override
  void initState() {
    super.initState();
    loadFiles();
  }

  Future<void> loadFiles() async {

    final entities =
    await _storageService.getEncryptedFiles();

    final loadedFiles = entities
        .whereType<File>()
        .map(
          (file) => FileModel(
        fileName:
        file.path.split('/').last,
        path: file.path,
        createdAt:
        file.lastModifiedSync(),
        size: file.lengthSync(),
      ),
    )
        .toList();

    setState(() {
      files = loadedFiles;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName),
      ),
      body: files.isEmpty
          ? const Center(
        child: Text(
          "No encrypted files found",
        ),
      )
          : ListView.builder(
        itemCount: files.length,
        itemBuilder:
            (context, index) {

          return FileTile(
            file: files[index],
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      FileViewScreen(
                        file:
                        files[index],
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}








