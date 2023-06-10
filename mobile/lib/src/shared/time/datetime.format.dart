import 'package:flutter/material.dart';

class DateTimeFormat {
  static String toYYYYMMDD(DateTime dateTime) {
    final String year = dateTime.year.toString();
    final String month = dateTime.month.toString().padLeft(2, '0');
    final String day = dateTime.day.toString().padLeft(2, '0');
    return "$year/$month/$day";
  }

  static String tohhmm(TimeOfDay timeOfDay) {
    final String hour = timeOfDay.hour.toString();
    final String minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
