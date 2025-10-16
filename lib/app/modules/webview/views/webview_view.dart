// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/modules/webview/controllers/webview_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// View
class WebviewView extends StatefulWidget {
  final String? url;
  final bool? isLinearProgressBar;
  final Color? statusBarColor;
  final bool? isCredit;

  const WebviewView({
    super.key,
    this.url,
    this.isLinearProgressBar = false,
    this.statusBarColor,
    this.isCredit = false,
  });

  @override
  State<WebviewView> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebviewView> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  final webViewModel = Get.put(WebViewController());

  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
    geolocationEnabled: true,
    javaScriptCanOpenWindowsAutomatically: true,
  );

  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();
    // Clear any previous errors
    webViewModel.clearError();

    // Initialize pull-to-refresh
    pullToRefreshController =
        kIsWeb ||
                ![
                  TargetPlatform.iOS,
                  TargetPlatform.android,
                ].contains(defaultTargetPlatform)
            ? null
            : PullToRefreshController(
              settings: PullToRefreshSettings(color: Colors.blue),
              onRefresh: () async {
                if (defaultTargetPlatform == TargetPlatform.android) {
                  webViewController?.reload();
                } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                  webViewController?.loadUrl(
                    urlRequest: URLRequest(
                      url: await webViewController?.getUrl(),
                    ),
                  );
                }
              },
            );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isCredit == false) {
          debugPrint("Credit===false");
          try {
            if (await webViewController?.canGoBack() ?? false) {
              webViewController?.goBack();
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          } catch (e) {
            debugPrint("Error in onWillPop: $e");
            return Future.value(true);
          }
        } else {
          debugPrint("Credit===true");
          return true;
        }
      },
      child: GetBuilder<WebViewController>(
        init: WebViewController(),
        builder: (controller) {
          return Scaffold(
         
            body: SafeArea(
              child: Obx(() {
                controller.progress.value;
                // Set status bar color
                SystemChrome.setSystemUIOverlayStyle(
                  SystemUiOverlayStyle(statusBarColor: widget.statusBarColor),
                );

                return webViewModel.webNotLoadError.value.isNotEmpty
                    ? _buildErrorUI(widget.url.toString())
                    : Stack(
                      children: <Widget>[
                        InAppWebView(
                          key: webViewKey,
                          initialUrlRequest: URLRequest(
                            url: WebUri(widget.url.toString()),
                          ),
                          initialSettings: settings,
                          pullToRefreshController: pullToRefreshController,
                          onWebViewCreated: (controller) {
                            webViewController = controller;
                          },
                          onLoadError: (controller, url, code, message) {
                            debugPrint("Error loading page: $message");
                            webViewModel.setError(message);
                          },
                          onLoadHttpError: (
                            controller,
                            url,
                            statusCode,
                            description,
                          ) {
                            debugPrint(
                              "HTTP Error: $statusCode - $description",
                            );
                          },
                          onLoadStart: (controller, url) {
                            webViewModel.updateUrl(url.toString());
                          },
                          onPermissionRequest: (controller, request) async {
                            return PermissionResponse(
                              resources: request.resources,
                              action: PermissionResponseAction.GRANT,
                            );
                          },
                          shouldOverrideUrlLoading: (
                            controller,
                            navigationAction,
                          ) async {
                            var uri = navigationAction.request.url!;
                            if (![
                              "http",
                              "https",
                              "file",
                              "chrome",
                              "data",
                              "javascript",
                              "about",
                            ].contains(uri.scheme)) {
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                                return NavigationActionPolicy.CANCEL;
                              }
                            }
                            return NavigationActionPolicy.ALLOW;
                          },
                          onLoadStop: (controller, url) async {
                            pullToRefreshController?.endRefreshing();
                            webViewModel.updateUrl(url.toString());
                          },
                          onProgressChanged: (controller, progress) {
                            if (progress == 100) {
                              pullToRefreshController?.endRefreshing();
                            }
                            Future.delayed(const Duration(milliseconds: 100));
                            webViewModel.updateProgress(progress / 100);
                          },
                          onUpdateVisitedHistory: (
                            controller,
                            url,
                            androidIsReload,
                          ) {
                            webViewModel.updateUrl(url.toString());
                          },
                          onConsoleMessage: (controller, consoleMessage) {
                            if (kDebugMode) {
                              print(consoleMessage);
                            }
                          },
                        ),
                        // Linear Progress Bar
                        (widget.isLinearProgressBar == true &&
                                webViewModel.progress.value < 1.0)
                            ? LinearProgressIndicator(
                              value: webViewModel.progress.value,
                              color: Colors.green,
                            )
                            : const SizedBox(),
                        // Circular Progress Indicator
                        (widget.isLinearProgressBar == false &&
                                webViewModel.progress.value < 1.0)
                            ? Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Transform.scale(
                                  scale: 0.4,
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                    strokeWidth: 10,
                                  ),
                                ),
                              ),
                            )
                            : const SizedBox(),
                      ],
                    );
             
              }),
            ),
       
          );
        },
      ),
    );
  }

  // Method to build the custom error UI
  Widget _buildErrorUI(String url) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.error, size: 50, color: Colors.red),
              const SizedBox(height: 20),
              const Text(
                "Check internet connection. Please check your network and try again.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  webViewModel.clearError();
                  webViewController?.loadUrl(
                    urlRequest: URLRequest(url: WebUri(url)),
                  );
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
   
  }

  @override
  void dispose() {
    // Optional: Remove controller if needed
    // Get.delete<WebViewController>();
    super.dispose();
  }
}
