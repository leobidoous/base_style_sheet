import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../core/themes/spacing/spacing.dart';
import 'custom_loading.dart';
import 'errors/custom_request_error.dart';

class CustomWebView extends StatefulWidget {
  const CustomWebView({
    super.key,
    required this.url,
    this.onProgress,
    this.onUrlChange,
    this.onNavigationRequest,
    this.onJavaScriptChannels,
  });

  final String url;
  final void Function(int)? onProgress;
  final void Function(UrlChange)? onUrlChange;
  final Map<String, void Function(JavaScriptMessage)?>? onJavaScriptChannels;
  final FutureOr<NavigationDecision> Function(NavigationRequest)?
      onNavigationRequest;

  @override
  CustomWebViewState createState() => CustomWebViewState();
}

class CustomWebViewState extends State<CustomWebView> {
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
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
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
          },
          onPageFinished: (String url) async {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
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
      )
      ..loadRequest(Uri.parse(widget.url));
    widget.onJavaScriptChannels?.entries.forEach((e) {
      controller.addJavaScriptChannel(
        e.key,
        onMessageReceived: e.value as void Function(JavaScriptMessage),
      );
    });

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
      (controller.platform as AndroidWebViewController)
          .setOnPlatformPermissionRequest((permissionRequest) {
        permissionRequest.grant();
      });
    }

    webViewController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return const Center(child: CustomLoading());
          } else if (hasError) {
            return Center(
              child: CustomRequestError(
                padding: EdgeInsets.all(Spacing.sm.value),
              ),
            );
          }
          return RepaintBoundary(
            child: SafeArea(
              child: WebViewWidget(controller: webViewController),
            ),
          );
        },
      ),
      bottomNavigationBar: Visibility(
        visible: progress != 0 && progress != 100,
        child: SafeArea(
          child: LinearProgressIndicator(
            minHeight: 2.5,
            value: progress / 100,
          ),
        ),
      ),
    );
  }
}
