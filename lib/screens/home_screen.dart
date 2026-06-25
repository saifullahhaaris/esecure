import 'package:flutter/material.dart';
import '../widgets/folder_tile.dart';
import '../services/file_picker_service.dart';
import 'folder_screen.dart';
import '../services/file_encryption_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FilePickerService _picker =
  FilePickerService();
  final FileEncryptionService _encryptionService =
  FileEncryptionService();

  Future<void> pickFile() async {

    try {

      final file =
      await _picker.pickFile();

      if (file == null) {
        return;
      }

      await _encryptionService.encryptAndStoreFile(
        file: file,
        password: "TestPassword123",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "File encrypted successfully",
          ),
        ),
      );

      setState(() {});

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ESecure"),
      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: pickFile,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [

          FolderTile(
            folderName: "Documents",
            icon: Icons.folder,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FolderScreen(
                    folderName: "Documents",
                  ),
                ),
              );
            },
          ),

          FolderTile(
            folderName: "Photos",
            icon: Icons.photo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FolderScreen(
                    folderName: "Photos",
                  ),
                ),
              );
            },
          ),

          FolderTile(
            folderName: "Videos",
            icon: Icons.video_collection,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FolderScreen(
                    folderName: "Videos",
                  ),
                ),
              );
            },
          ),

          FolderTile(
            folderName: "Notes",
            icon: Icons.note,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FolderScreen(
                    folderName: "Notes",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}