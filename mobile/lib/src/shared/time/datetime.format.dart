class DateTimeFormat {
  static String toYYYYMMDD(DateTime dateTime) {
    final String year = dateTime.year.toString();
    final String month = dateTime.month.toString().padLeft(2, '0');
    final String day = dateTime.day.toString().padLeft(2, '0');
    return "$year-$month-$day";
  }
}
