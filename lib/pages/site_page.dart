import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SitePage extends StatelessWidget {
  WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Site",
        ),
      ),
      body: _body(),
    );
  }

  _body() {
    return WebView(
      initialUrl: "https://flutter.dev/",
      onWebViewCreated: (controller) {
        this.controller = controller;
      },
      javascriptMode: JavascriptMode.unrestricted,
      navigationDelegate: (request) {
        print("Url: ${request.url}");
        return NavigationDecision.navigate;
      },
    );
  }
}
