

/// Categorize reports into sections
String getSectionLabel(DateTime date) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = today.subtract(Duration(days: 1));
  DateTime lastWeek = today.subtract(Duration(days: 7));

  if (date.isAfter(today)) {
    return "Today";
  } else if (date.isAfter(yesterday)) {
    return "Yesterday";
  } else if (date.isAfter(lastWeek)) {
    return "Last Week";
  } else {
    return "Older";
  }
}