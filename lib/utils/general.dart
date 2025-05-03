import 'package:intl/intl.dart';

String capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}

String getDiaSemanaPt(DateTime date) {
  String dia = DateFormat('EEEE', 'pt_PT').format(date);

  return capitalize(dia);
}
