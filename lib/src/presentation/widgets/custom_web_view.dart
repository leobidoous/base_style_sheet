import 'dart:async';

import 'package:flutter/foundation.dart';
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
    this.onProgress,
    this.onUrlChange,
    required this.url,
    this.onPageStarted,
    this.onPageFinished,
    this.headers = const {},
    this.onWebResourceError,
    this.onNavigationRequest,
    this.onJavaScriptChannels,
  });

  final String url;
  final Map<String, String> headers;
  final void Function(int)? onProgress;
  final void Function(String)? onPageStarted;
  final void Function(UrlChange)? onUrlChange;
  final void Function(String)? onPageFinished;
  final void Function(WebResourceError)? onWebResourceError;
  final Map<String, void Function(JavaScriptMessage)?>? onJavaScriptChannels;
  final FutureOr<NavigationDecision> Function(NavigationRequest)?
  onNavigationRequest;

  @override
  CustomWebViewState createState() => CustomWebViewState();
}

class CustomWebViewState extends State<CustomWebView> {
  late final WebViewController _webViewController;
  final bool _isLoading = false;
  final bool _hasError = false;
  int _progress = 0;

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

    _webViewController = WebViewController.fromPlatformCreationParams(
      params,
      onPermissionRequest: kIsWeb
          ? null
          : (request) {
              request.platform.grant();
            },
    );

    if (!kIsWeb) {
      _webViewController
        ..setBackgroundColor(Colors.transparent)
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int value) {
              if (mounted) {
                setState(() => _progress = value);
              }
              widget.onProgress?.call(value);
            },
            onPageStarted:
                widget.onPageStarted ??
                (String url) {
                  debugPrint('Page started loading: $url');
                },
            onPageFinished:
                widget.onPageFinished ??
                (String url) {
                  debugPrint('Page finished loading: $url');
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
            onUrlChange:
                widget.onUrlChange ??
                (UrlChange change) {
                  debugPrint('Url changed: ${change.url}');
                },
          ),
        )
        ..loadRequest(Uri.parse(widget.url), headers: widget.headers);
    } else {
      _webViewController.loadRequest(
        Uri.parse(widget.url),
        headers: widget.headers,
      );
    }

    widget.onJavaScriptChannels?.entries.forEach((e) {
      _webViewController.addJavaScriptChannel(
        e.key,
        onMessageReceived: e.value as void Function(JavaScriptMessage),
      );
    });

    if (_webViewController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_webViewController.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
      (_webViewController.platform as AndroidWebViewController)
          .setOnPlatformPermissionRequest((permissionRequest) {
            permissionRequest.grant();
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return const Center(child: CustomLoading());
          } else if (_hasError) {
            return Center(
              child: CustomRequestError(padding: .all(Spacing.sm.value)),
            );
          }
          return SafeArea(child: WebViewWidget(controller: _webViewController));
        },
      ),
      bottomNavigationBar: Visibility(
        visible: _progress != 0 && _progress != 100,
        child: SafeArea(
          child: LinearProgressIndicator(
            minHeight: 2.5,
            value: _progress / 100,
          ),
        ),
      ),
    );
  }
}
