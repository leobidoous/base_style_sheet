import 'package:file_picker/file_picker.dart' show FilePicker, FileType;

import '../../../base_style_sheet.dart' show PlatformFile;

class FilePickerController {
  final _platform = FilePicker.platform;

  String filePath = '';

  Future<String> pickFilePath({
    FileType fileType = FileType.custom,
    List<String> allowedExtensions = const ['pdf'],
  }) async {
    return _platform
        .pickFiles(
          type: fileType,
          compressionQuality: 10,
          allowedExtensions: allowedExtensions,
        )
        .then((onValue) {
          if ((onValue?.count ?? 0) <= 0) return '';

          return onValue?.files.first.path ?? '';
        });
  }
  Future<List<PlatformFile>> pickFile({
    FileType fileType = FileType.custom,
    List<String> allowedExtensions = const ['pdf'],
  }) async {
    return _platform
        .pickFiles(
          type: fileType,
          compressionQuality: 10,
          allowedExtensions: allowedExtensions,
        )
        .then((onValue) {
          if ((onValue?.count ?? 0) <= 0) return const [];

          return onValue?.files ?? const [];
        });
  }
}
