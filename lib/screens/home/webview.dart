import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  WebViewScreen({this.url, this.title});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  var controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      controller = WebViewController()..loadRequest(Uri.parse(widget.url))..setJavaScriptMode(JavaScriptMode.unrestricted);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: WebViewWidget(controller: controller),
    );
  }
}
