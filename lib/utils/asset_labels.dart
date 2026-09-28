// utils/asset_labels.dart
const Map<String, String> assetLabels = {
  'gold': 'Gold',
  'nikkei': 'JPK',
  'hangseng': 'HKK',
};

String assetLabel(String? key) {
  if (key == null) return '-';
  return assetLabels[key] ?? key;
}