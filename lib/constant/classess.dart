// ignore_for_file: non_constant_identifier_names

import 'package:shamsi_date/shamsi_date.dart';

import '../widget/custom_messages.dart';
import 'package:timeago/timeago.dart' as timeago;

enum CategoryType { text, number, select }

enum ContactRadioList { call, chat, both }

enum MyAdsStatus { waiting, accepted, rejected ,pending}

extension ss on String {
  String get_created_at() {
    timeago.setLocaleMessages('fa', PersianLanguage());

    DateTime dateTime = DateTime.parse(Shamsitogregorian(this).toString());
    DateTime minedDateTime = dateTime.add(Duration(hours: 4));

    return timeago.format(minedDateTime, locale: "fa",);
  }
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = Set();
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

Shamsitogregorian(String gregorianDateString) {
  Gregorian dati = Gregorian.fromDateTime(DateTime.parse(gregorianDateString));
  Jalali jj = Jalali(dati.year, dati.month, dati.day, dati.hour, dati.minute);
  Gregorian dati2 = jj.toGregorian();
  DateTime dt =
      DateTime(dati2.year, dati2.month, dati2.day, dati2.hour, dati2.minute);

  return dt;
}
