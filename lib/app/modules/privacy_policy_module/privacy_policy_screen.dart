import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/appColors.dart';
import '../../utils/appFonts.dart';
import '../../utils/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  PrivacyPolicyScreen({super.key});

  final String privacyUrl = "https://myephysician.com/myratingsystem/adminPanel/privacypolicy";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          Strings.privacyPolicy,
          style: AppFonts.rubik.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: const WebViewWrapper(),
    );
  }
}

class WebViewWrapper extends StatefulWidget {
  const WebViewWrapper({super.key});

  @override
  State<WebViewWrapper> createState() => _WebViewWrapperState();
}

class _WebViewWrapperState extends State<WebViewWrapper> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (_) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse("https://myephysician.com/myratingsystem/adminPanel/privacypolicy"),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading)
          const LinearProgressIndicator(
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            minHeight: 2,
          ),
        Expanded(child: WebViewWidget(controller: _controller)),
      ],
    );
  }
}



