import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../custom_dialog.dart';

class CustomPdfView extends StatefulWidget {
  const CustomPdfView({super.key, this.asset, this.url, this.file});

  final String? url;
  final String? asset;
  final File? file;

  @override
  State<CustomPdfView> createState() => _CustomPdfViewState();
}

class _CustomPdfViewState extends State<CustomPdfView> {
  final controller = PdfViewerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url != null) {
      return SfPdfViewer.network(
        widget.url!,
        controller: controller,
        pageLayoutMode: PdfPageLayoutMode.continuous,
        onDocumentLoadFailed: (details) async {
          await CustomDialog.error(
            context,
            message: details.description,
          ).then((value) => Navigator.of(context).pop());
        },
      );
    } else if (widget.asset != null) {
      return SfPdfViewer.asset(widget.asset!);
    } else if (widget.file != null) {
      return SfPdfViewer.file(widget.file!);
    } else {
      return const SizedBox();
    }
  }
}
