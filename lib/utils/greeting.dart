// utils/greeting.dart

/// Waktu sekarang di WIB (UTC+7).
/// Dihitung dari UTC, jadi tidak bergantung pada zona waktu yang di-set di HP.
DateTime nowWib() => DateTime.now().toUtc().add(const Duration(hours: 7));

/// Sapaan sesuai jam WIB:
///   04.00 - 10.59  Good Morning
///   11.00 - 14.59  Good Afternoon
///   15.00 - 17.59  Good Evening
///   18.00 - 03.59  Good Night
String greetingWib([DateTime? wib]) {
  final hour = (wib ?? nowWib()).hour;
  if (hour >= 4 && hour < 11) return 'Good Morning';
  if (hour >= 11 && hour < 15) return 'Good Afternoon';
  if (hour >= 15 && hour < 18) return 'Good Evening';
  return 'Good Night';
}