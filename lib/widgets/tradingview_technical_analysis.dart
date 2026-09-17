import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingViewTechnicalAnalysis extends StatefulWidget {
  final String symbol; // contoh: 'Saxo:XAUUSD'
  final double height;

  const TradingViewTechnicalAnalysis({
    super.key,
    required this.symbol,
    this.height = 450,
  });

  @override
  State<TradingViewTechnicalAnalysis> createState() => _TradingViewTechnicalAnalysisState();
}

class _TradingViewTechnicalAnalysisState extends State<TradingViewTechnicalAnalysis> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            debugPrint('❌ TechnicalAnalysis WebView error: ${error.description}');
          },
        ),
      )
      ..loadHtmlString(_buildHtml(widget.symbol), baseUrl: 'https://www.tradingview.com');
  }

  @override
  void didUpdateWidget(covariant TradingViewTechnicalAnalysis oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.symbol != widget.symbol) {
      _controller.loadHtmlString(_buildHtml(widget.symbol), baseUrl: 'https://www.tradingview.com');
    }
  }

  String _buildHtml(String symbol) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    html, body { margin:0; padding:0; background:#ffffff; }
    tv-technical-analysis { display:block; width:100%; height:100%; }
  </style>
</head>
<body>
  <tv-technical-analysis symbol="$symbol"></tv-technical-analysis>
  <script type="module" src="https://widgets.tradingview-widget.com/w/en/tv-technical-analysis.js"></script>
</body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: widget.height, child: WebViewWidget(controller: _controller));
  }
}