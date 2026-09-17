import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingViewSymbolInfo extends StatefulWidget {
  final String symbol; // contoh: 'Saxo:XAUUSD'
  final double height; // tinggi awal, sebelum widget selesai render

  const TradingViewSymbolInfo({
    super.key,
    required this.symbol,
    this.height = 190,
  });

  @override
  State<TradingViewSymbolInfo> createState() => _TradingViewSymbolInfoState();
}

class _TradingViewSymbolInfoState extends State<TradingViewSymbolInfo> {
  late final WebViewController _controller;
  double _renderedHeight = 190;

  @override
  void initState() {
    super.initState();
    _renderedHeight = widget.height;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..enableZoom(false)
      ..addJavaScriptChannel(
        'FlutterHeight',
        onMessageReceived: (message) {
          final h = double.tryParse(message.message);
          if (h == null || !mounted) return;
          // Kunci penting: HANYA membesar, gak pernah ngecil.
          // Biar gak "nyangkut" di ukuran toolbar doang sebelum card-nya kelar render.
          if (h > _renderedHeight) {
            setState(() => _renderedHeight = h + 4);
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            debugPrint('❌ SymbolInfo WebView error: ${error.description}');
          },
        ),
      )
      ..loadHtmlString(_buildHtml(widget.symbol), baseUrl: 'https://www.tradingview.com');
  }

  @override
  void didUpdateWidget(covariant TradingViewSymbolInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.symbol != widget.symbol) {
      setState(() => _renderedHeight = widget.height);
      _controller.loadHtmlString(_buildHtml(widget.symbol), baseUrl: 'https://www.tradingview.com');
    }
  }

  String _slug(String symbol) => symbol.replaceAll(':', '-');
  String _ticker(String symbol) => symbol.contains(':') ? symbol.split(':').last : symbol;

  String _buildHtml(String symbol) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    html, body { margin:0; padding:0; background:#ffffff; }
    .tradingview-widget-container { width: 100%; }
  </style>
</head>
<body>
  <div class="tradingview-widget-container">
    <div class="tradingview-widget-container__widget"></div>
    <div class="tradingview-widget-copyright">
      <a href="https://www.tradingview.com/symbols/${_slug(symbol)}/" rel="noopener nofollow" target="_blank">
        <span class="blue-text">${_ticker(symbol)} performance</span>
      </a>
      <span class="trademark"> by TradingView</span>
    </div>
  </div>
  <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-symbol-info.js" async>
  {
    "symbol": "$symbol",
    "colorTheme": "light",
    "isTransparent": false,
    "locale": "en",
    "width": "100%"
  }
  </script>
  <script>
    (function () {
      var lastReported = 0;
      function reportHeight() {
        var el = document.querySelector('.tradingview-widget-container');
        if (!el) return;
        var h = el.scrollHeight;
        if (h > 0 && h > lastReported) {
          lastReported = h;
          FlutterHeight.postMessage(String(h));
        }
      }
      // Poll tiap 320ms selama ~8 detik — widget TradingView render bertahap
      // (toolbar dulu, baru card harga), jadi kita terus cek sampai stabil.
      var tries = 0;
      var interval = setInterval(function () {
        reportHeight();
        tries++;
        if (tries > 25) clearInterval(interval);
      }, 320);
    })();
  </script>
</body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: SizedBox(height: _renderedHeight, child: WebViewWidget(controller: _controller)),
    );
  }
}