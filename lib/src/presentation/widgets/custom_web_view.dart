import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../core/themes/spacing/spacing.dart';
import '../controllers/file_picker_controller.dart';
import '../extensions/build_context_extensions.dart';
import 'custom_loading.dart';
import 'errors/custom_request_error.dart';

class CustomWebView extends StatefulWidget {
  const CustomWebView({
    super.key,
    this.url,
    this.html,
    this.onProgress,
    this.onUrlChange,
    this.onPageStarted,
    this.onPageFinished,
    this.headers = const {},
    this.onWebResourceError,
    this.onNavigationRequest,
    this.onJavaScriptChannels,
  });

  final String? url;
  final String? html;
  final Map<String, String> headers;
  final void Function(int progress)? onProgress;
  final void Function(UrlChange urlChange)? onUrlChange;
  final void Function(WebResourceError error)? onWebResourceError;
  final void Function(WebViewController controller)? onPageStarted;
  final void Function(WebViewController controller)? onPageFinished;
  final Map<String, void Function(JavaScriptMessage message)?>?
  onJavaScriptChannels;
  final FutureOr<NavigationDecision> Function(NavigationRequest request)?
  onNavigationRequest;

  @override
  CustomWebViewState createState() => CustomWebViewState();
}

class CustomWebViewState extends State<CustomWebView> {
  final _filePickerController = FilePickerController();
  late final WebViewController webViewController;
  int progress = 0;
  bool isLoading = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(
      params,
      onPermissionRequest: (request) {
        request.platform.grant();
      },
    );

    controller
      ..setJavaScriptMode(.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() => this.progress = progress);
            }
            widget.onProgress?.call(progress);
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
            widget.onPageStarted?.call(controller);
          },
          onPageFinished: (String url) async {
            debugPrint('Page finished loading: $url');
            widget.onPageFinished?.call(controller);
          },
          onWebResourceError:
              widget.onWebResourceError ??
              (WebResourceError error) {
                debugPrint('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
          ''');
              },
          onNavigationRequest: widget.onNavigationRequest,
          onUrlChange: widget.onUrlChange,
        ),
      );
    widget.onJavaScriptChannels?.entries.forEach((e) {
      controller.addJavaScriptChannel(
        e.key,
        onMessageReceived: e.value as void Function(JavaScriptMessage),
      );
    });

    if (widget.url != null && widget.url!.isNotEmpty) {
      controller.loadRequest(Uri.parse(widget.url!), headers: widget.headers);
    }
    if (widget.html != null && widget.html!.isNotEmpty) {
      controller.loadHtmlString(widget.html!);
    }

    if (controller.platform is AndroidWebViewController) {
      final androidController = controller.platform as AndroidWebViewController;
      AndroidWebViewController.enableDebugging(kDebugMode);
      androidController.setMediaPlaybackRequiresUserGesture(false);
      androidController.setOnPlatformPermissionRequest((permissionRequest) {
        permissionRequest.grant();
      });

      // Habilita o <input type="file"> no Android. Sem este handler o seletor
      // de arquivos não abre (no iOS/WKWebView funciona nativamente).
      androidController.setOnShowFileSelector(_androidFilePicker);
    }

    controller.clearCache();
    webViewController = controller;
  }

  /// Abre o seletor de arquivos nativo do Android quando a página web
  /// dispara um `<input type="file">` e retorna os URIs selecionados.
  Future<List<String>> _androidFilePicker(FileSelectorParams params) async {
    try {
      final files = await _filePickerController.pickFile(
        fileType: .custom,
        allowedExtensions: params.acceptTypes.isEmpty
            ? ['pdf', 'png', 'jpg', 'jpeg']
            : params.acceptTypes.map((e) => e.split('/').last).toList(),
      );

      return files
          .map((file) => file.path)
          .whereType<String>()
          .map((path) => Uri.file(path).toString())
          .toList();
    } catch (e) {
      debugPrint('PayPayWebView._androidFilePicker error: $e');
      return const <String>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.isDarkMode
          ? context.theme.scaffoldBackgroundColor
          : context.colorScheme.surface,
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return Center(
              child: CustomLoading(primaryColor: context.colorScheme.primary),
            );
          } else if (hasError) {
            return Center(
              child: CustomRequestError(padding: .all(Spacing.sm.value)),
            );
          }
          return SafeArea(child: WebViewWidget(controller: webViewController));
        },
      ),
      bottomNavigationBar: Visibility(
        visible: progress != 0 && progress != 100,
        child: SafeArea(
          child: LinearProgressIndicator(minHeight: 2.5, value: progress / 100),
        ),
      ),
    );
  }
}
