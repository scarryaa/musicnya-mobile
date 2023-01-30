class MillisecondsToDateTime {
  static String millisecondsToFormattedString(int milliseconds) {
    var datetime = DateTime(0).add(Duration(milliseconds: milliseconds));
    var hoursOrHour = datetime.hour == 1 ? "hour" : "hours";
    var minutesOrMinute = datetime.minute == 1 ? "minute" : "minutes";
    return '${(datetime.hour == 0) ? '' : '${datetime.hour} $hoursOrHour, '}${datetime.minute} $minutesOrMinute';
  }

  static String millisecondsToClockFormat(int milliseconds) {
    var datetime = DateTime(0).add(Duration(milliseconds: milliseconds));
    return ((datetime.minute == 0)
        ? '0:${(datetime.second == 0) ? '00' : datetime.second.toString().padLeft(2, "0")}'
        : '${datetime.minute}:${datetime.second.toString().padLeft(2, "0")}');
  }
}
