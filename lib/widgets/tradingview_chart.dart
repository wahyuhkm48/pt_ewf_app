import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingViewChart extends StatefulWidget {
  final String symbol;   // contoh: 'OANDA:XAUUSD'
  final String interval; // '15', '60', 'D'
  final double height;

  const TradingViewChart({
    super.key,
    required this.symbol,
    this.interval = 'D',
    this.height = 400,
  });

  @override
  State<TradingViewChart> createState() => _TradingViewChartState();
}

class _TradingViewChartState extends State<TradingViewChart> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..enableZoom(false)
      ..addJavaScriptChannel(
        'FlutterConsole',
        onMessageReceived: (message) {
          debugPrint('🟡 JS LOG: ${message.message}');
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            debugPrint('❌ TradingView WebView error: ${error.description} (code: ${error.errorCode}, type: ${error.errorType})');
          },
          onPageFinished: (url) async {
            debugPrint('✅ TradingView WebView page finished loading: $url');
            await Future.delayed(const Duration(seconds: 3));
            try {
              final result = await _controller.runJavaScriptReturningResult(
                "document.querySelector('.tradingview-widget-container__widget').innerHTML.length"
              );
              debugPrint('🔍 (setelah 3 detik) Widget container innerHTML length: $result');
            } catch (e) {
              debugPrint('🔍 Gagal cek innerHTML: $e');
            }
          },
          onProgress: (progress) {
            debugPrint('⏳ TradingView WebView loading: $progress%');
          },
        ),
      )
      ..loadHtmlString(
        _buildHtml(widget.symbol, widget.interval),
        baseUrl: 'https://www.tradingview.com',
      );
  }

  @override
  void didUpdateWidget(covariant TradingViewChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.symbol != widget.symbol || oldWidget.interval != widget.interval) {
      _controller.loadHtmlString(
        _buildHtml(widget.symbol, widget.interval),
        baseUrl: 'https://www.tradingview.com',
      );
    }
  }

  String _buildHtml(String symbol, String interval) {
    final chartHeight = widget.height.toInt();
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    html, body { margin:0; padding:0; background:#ffffff; }
    .tradingview-widget-container {
      width: 100%;
      height: ${chartHeight}px;
    }
    .tradingview-widget-container__widget {
      width: 100%;
      height: ${chartHeight}px;
    }
  </style>
</head>
<body>
  <script>
    window.onerror = function(message, source, lineno, colno, error) {
      FlutterConsole.postMessage('window.onerror: ' + message + ' at ' + source + ':' + lineno);
    };
  </script>
  <div class="tradingview-widget-container">
    <div class="tradingview-widget-container__widget"></div>
  </div>
  <script>
    var s = document.createElement('script');
    s.src = 'https://s3.tradingview.com/external-embedding/embed-widget-advanced-chart.js';
    s.type = 'text/javascript';
    s.async = true;
    s.onload = function() {
      FlutterConsole.postMessage('script onload: BERHASIL di-download');
    };
    s.onerror = function(e) {
      FlutterConsole.postMessage('script onerror: GAGAL di-download - ' + JSON.stringify(e));
    };
    s.innerHTML = JSON.stringify({
      "allow_symbol_change": true,
      "calendar": false,
      "details": false,
      "hide_side_toolbar": true,
      "hide_top_toolbar": false,
      "hide_legend": false,
      "hide_volume": false,
      "hotlist": false,
      "interval": "$interval",
      "locale": "en",
      "save_image": false,
      "style": "1",
      "symbol": "$symbol",
      "theme": "light",
      "timezone": "Etc/UTC",
      "backgroundColor": "#ffffff",
      "gridColor": "rgba(46, 46, 46, 0.2)",
      "watchlist": [],
      "withdateranges": false,
      "compareSymbols": [],
      "support_host": "https://www.tradingview.com",
      "studies": [],
      "width": "100%",
      "height": $chartHeight
    });
    document.querySelector('.tradingview-widget-container').appendChild(s);
  </script>
</body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: WebViewWidget(controller: _controller),
    );
  }
}