
import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
 import 'package:webview_flutter/webview_flutter.dart' as webview_flutter;
// import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io' show HttpResponse, Platform;

import 'package:webview_flutter/webview_flutter.dart';




class FormSubmit extends StatefulWidget {
  final String htmlCode;

  FormSubmit(this.htmlCode);
  State<StatefulWidget> createState() {
    return _FormSubmitState();
  }
}

class _FormSubmitState extends State<FormSubmit> {

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

 //   FormSubmit(String formHtml)
 //       : html = """<html>
 // <body onload="document.getElementsByTagName('form')[0].submit();">
 //   <p>Loading...</p>
 //   <div style="opacity: 0">$formHtml</div>
 // </body>
 // </html>""";
  String html = """<html>
  <body onload="document.getElementsByTagName('form')[0].submit();">
    <p>Loading...</p>
    <div>Hello Welcome</div>
  </body>
  </html>""";

   @override
   Widget build(BuildContext context) => Scaffold(
     appBar: AppBar(),
     body: webview_flutter.WebView(
       initialUrl: Uri.dataFromString(
         widget.htmlCode,
         mimeType: 'text/html',
       ).toString(),
       javascriptMode: webview_flutter.JavascriptMode.unrestricted,
     ),
   );
 }