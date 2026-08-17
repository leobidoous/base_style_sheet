import 'package:file_picker/file_picker.dart' show FilePicker, FileType;

import '../../../base_style_sheet.dart' show PlatformFile;

class FilePickerController {
  String filePath = '';

  Future<String> pickFilePath({
    FileType fileType = FileType.custom,
    List<String> allowedExtensions = const ['pdf'],
  }) async {
    final files = await FilePicker.pickFiles(
      type: fileType,
      allowedExtensions: allowedExtensions,
    );

    if (files.isEmpty) return '';
    return files.first.path ?? '';
  }

  Future<List<PlatformFile>> pickFile({
    FileType fileType = FileType.custom,
    List<String> allowedExtensions = const ['pdf'],
  }) async {
    final files = await FilePicker.pickFiles(
      type: fileType,
      allowedExtensions: allowedExtensions,
    );

    if (files.isEmpty) return const [];
    return files;
  }
}
