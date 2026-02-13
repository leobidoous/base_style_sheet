import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../core/themes/app_theme_factory.dart';
import '../../../core/themes/typography/typography_constants.dart';
import '../../../domain/enums/custom_pdf_view_mode.dart';
import '../../extensions/build_context_extensions.dart';
import '../custom_app_bar.dart';
import '../custom_dialog.dart';

class CustomPdfView extends StatefulWidget {
  const CustomPdfView({
    super.key,
    this.asset,
    this.url,
    this.file,
    this.headers,
    this.actions = const [],
    this.viewMode = CustomPdfViewMode.page,
  });

  final File? file;
  final String? url;
  final String? asset;
  final List<Widget> actions;
  final CustomPdfViewMode viewMode;
  final Map<String, String>? headers;

  @override
  State<CustomPdfView> createState() => _CustomPdfViewState();

  Future<void> show(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (_, animation, animation2, child) {
          const begin = Offset(0, 1);
          const end = Offset.zero;
          const curve = Curves.decelerate;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return CustomPdfView(
            file: file,
            url: url,
            asset: asset,
            headers: headers,
            actions: actions,
          );
        },
      ),
    );
  }
}

class _CustomPdfViewState extends State<CustomPdfView>
    with SingleTickerProviderStateMixin {
  late final Animation<double> _animation;
  final _pdfController = PdfViewerController();
  late final AnimationController _animationController;
  final _duration = const Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
    );
    _animation = Tween<double>(begin: 1, end: 0).animate(_animationController);
  }

  @override
  void dispose() {
    _pdfController.dispose();
    _animationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: switch (widget.viewMode) {
        CustomPdfViewMode.page => PreferredSize(
          preferredSize: Size(
            double.infinity,
            context.theme.appBarTheme.appBarHeight,
          ),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (_, child) {
              return FadeTransition(
                opacity: _animation,
                child: SizeTransition(
                  sizeFactor: _animation,
                  child: CustomAppBar(
                    actions: widget.actions,
                    leadingIcon: Icon(
                      Icons.close_rounded,
                      size: AppFontSize.iconButton.value,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        CustomPdfViewMode.view => null,
      },
      body: Semantics(
        button: true,
        child: InkWell(
          onTap: switch (widget.viewMode) {
            CustomPdfViewMode.page => () {
              if (_animationController.isDismissed) {
                _animationController.forward();
                SystemChrome.setEnabledSystemUIMode(.immersive);
              } else {
                _animationController.reverse();
                SystemChrome.setEnabledSystemUIMode(.edgeToEdge);
              }
            },
            CustomPdfViewMode.view => null,
          },
          child: SafeArea(
            child: Theme(
              data: context.theme.copyWith(),
              child: Builder(
                builder: (context) {
                  if (widget.url != null) {
                    return SfPdfViewer.network(
                      widget.url!,
                      headers: widget.headers,
                      controller: _pdfController,
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
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
