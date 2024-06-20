import 'package:intl/intl.dart';

//formar currency Rp x.xxx.xxx
NumberFormat getCurrencyFormatter() {
  return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
}
//format date with time
DateFormat getDateTimeFormatter() {
  return DateFormat('d MMM yyyy hh:mma');
}

//format date only
DateFormat getDateFormatter() {
  return DateFormat('d MMM yyyy');
}