import 'package:intl/intl.dart';

final NumberFormat _ilsFormat = NumberFormat.currency(
  locale: 'en',
  symbol: '₪',
  decimalDigits: 2,
);

String formatMoneyCents(int cents) {
  return _ilsFormat.format(cents / 100.0);
}
