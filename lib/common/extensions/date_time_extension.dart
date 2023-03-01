extension DateTimeExtension on DateTime {
  String toFormattedDateString() {
    String dateFormatted = "";
    dateFormatted += toFormattedWeekDayString();
    switch (month) {
      case DateTime.january:
        {
          dateFormatted += "Jan ";
          break;
        }
      case DateTime.february:
        {
          dateFormatted += "Feb ";
          break;
        }
      case DateTime.march:
        {
          dateFormatted += "Mar ";
          break;
        }
      case DateTime.april:
        {
          dateFormatted += "Apr, ";
          break;
        }
      case DateTime.may:
        {
          dateFormatted += "May ";
          break;
        }
      case DateTime.june:
        {
          dateFormatted += "Jun ";
          break;
        }
      case DateTime.july:
        {
          dateFormatted += "Jul ";
          break;
        }
      case DateTime.august:
        {
          dateFormatted += "Aug ";
          break;
        }
      case DateTime.september:
        {
          dateFormatted += "Sep ";
          break;
        }
      case DateTime.october:
        {
          dateFormatted += "Oct ";
          break;
        }
      case DateTime.november:
        {
          dateFormatted += "Nov ";
          break;
        }
      case DateTime.december:
        {
          dateFormatted += "Dec ";
          break;
        }
    }
    dateFormatted += "$year";
    return dateFormatted;
  }

  String toFormattedWeekDayString() {
    String dateFormatted = "";
    switch (weekday) {
      case DateTime.monday:
        {
          dateFormatted += "Mon, ";
          break;
        }
      case DateTime.tuesday:
        {
          dateFormatted += "Tue, ";
          break;
        }
      case DateTime.wednesday:
        {
          dateFormatted += "Wed, ";
          break;
        }
      case DateTime.thursday:
        {
          dateFormatted += "Thu, ";
          break;
        }
      case DateTime.friday:
        {
          dateFormatted += "Fri, ";
          break;
        }
      case DateTime.saturday:
        {
          dateFormatted += "Sat, ";
          break;
        }
      case DateTime.sunday:
        {
          dateFormatted += "Sun, ";
          break;
        }
    }
    dateFormatted += "$day ";
    return dateFormatted;
  }

  String toMonthAndYearString() {
    String dateFormatted = "";

    switch (month) {
      case DateTime.january:
        {
          dateFormatted += "January ";
          break;
        }
      case DateTime.february:
        {
          dateFormatted += "February ";
          break;
        }
      case DateTime.march:
        {
          dateFormatted += "March ";
          break;
        }
      case DateTime.april:
        {
          dateFormatted += "April ";
          break;
        }
      case DateTime.may:
        {
          dateFormatted += "May ";
          break;
        }
      case DateTime.june:
        {
          dateFormatted += "June ";
          break;
        }
      case DateTime.july:
        {
          dateFormatted += "July ";
          break;
        }
      case DateTime.august:
        {
          dateFormatted += "August ";
          break;
        }
      case DateTime.september:
        {
          dateFormatted += "September ";
          break;
        }
      case DateTime.october:
        {
          dateFormatted += "October ";
          break;
        }
      case DateTime.november:
        {
          dateFormatted += "November ";
          break;
        }
      case DateTime.december:
        {
          dateFormatted += "December ";
          break;
        }
    }
    dateFormatted += year.toString();
    return dateFormatted;
  }

  String toFormattedTimeOfDayString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  DateTime yearAndMonth() {
    return DateTime(year, month);
  }
}
