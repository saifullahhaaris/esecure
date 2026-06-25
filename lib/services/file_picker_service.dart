import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FilePickerService {

  Future<File?> pickFile() async {

    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result == null) {
      return null;
    }

    return File(
      result.files.single.path!,
    );
  }

  Future<List<int>?> pickFileBytes() async {

    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true,
    );

    if (result == null) {
      return null;
    }

    return result.files.single.bytes;
  }
}







