import 'package:flutter/material.dart';

class FolderTile extends StatelessWidget {
  final String folderName;
  final IconData icon;
  final VoidCallback onTap;

  const FolderTile({
    super.key,
    required this.folderName,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.amber),
        title: Text(folderName),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}