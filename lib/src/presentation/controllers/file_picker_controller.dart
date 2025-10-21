import 'package:file_picker/file_picker.dart' show FilePicker, FileType;

class FilePickerController {
  final _platform = FilePicker.platform;

  String filePath = '';

  Future<String> pickFile({
    FileType fileType = FileType.custom,
    List<String>? allowedExtensions = const ['.pdf'],
  }) async {
    return _platform
        .pickFiles(
          type: fileType,
          compressionQuality: 10,
          allowedExtensions: allowedExtensions,
        )
        .then((onValue) {
          if ((onValue?.count ?? 0) <= 0) return '';

          return onValue!.files.first.path ?? '';
        });
  }
}
