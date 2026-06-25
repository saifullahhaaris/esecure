import 'package:flutter/material.dart';
import '../models/file_model.dart';
import '../utils/helper_functions.dart';

class FileTile extends StatelessWidget {
  final FileModel file;
  final VoidCallback onTap;

  const FileTile({
    super.key,
    required this.file,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.lock),
        title: Text(file.fileName),
        subtitle: Text(
          "${HelperFunctions.formatBytes(file.size, 2)} • "
          "${HelperFunctions.formatDate(file.createdAt)}",
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}