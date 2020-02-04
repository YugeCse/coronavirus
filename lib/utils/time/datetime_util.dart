extension DateTimeUtil on DateTime {
  /// 获取两个时间的时间差, 默认数据结果是Milliseconds，否则是microsecond
  int getDiffTime(DateTime time, {bool isMillisecondsSinceEpoch = true}) {
    DateTime begin, end;
    if (time.isAfter(this)) {
      begin = this;
      end = time;
    } else {
      begin = time;
      end = this;
    }
    return isMillisecondsSinceEpoch
        ? begin.millisecondsSinceEpoch - end.millisecondsSinceEpoch
        : begin.microsecondsSinceEpoch - end.microsecondsSinceEpoch;
  }

  /// 获取两个时间的时间差
  Duration getDiffTimeDuration(DateTime time) =>
      Duration(milliseconds: getDiffTime(time));
}

extension DateTimeObjectUtil on Object {
  /// 转换成时间对象
  ///
  /// [time]-时间参数，可选类型：int, String, DateTime
  DateTime toDateTime() {
    DateTime dateTime;
    if (this is int || (this is String && RegExp(r'^\d+$').hasMatch(this))) {
      int newTime;
      newTime = this is int ? this : int.parse(this);
      int len = this.toString().length;
      if (len == 10) newTime *= 1000;
      dateTime = DateTime.fromMillisecondsSinceEpoch(newTime);
    } else if (this is String) {
      dateTime = DateTime.parse(this);
    } else if (this is DateTime) {
      dateTime = this;
    }
    return dateTime;
  }

  /// 转换成时间字符串
  ///
  /// [time]-时间参数，可选类型：int, String, DateTime
  ///
  /// [isShowDate]-是否显示日期，默认为： true
  ///
  /// [isShowSecond]-是否显示秒，默认为： true
  String toDateString({bool isShowDate = true, bool isShowSecond = true}) {
    String result = toDateTime()
        .toString()
        .replaceAll(r'T', ' ')
        .replaceAll(RegExp(r'\.\d+(z|Z)?$'), '');
    if (!isShowDate) result = result.replaceAll(RegExp(r'^[^\s]+\s'), '');
    if (!isShowSecond) result = result.replaceAll(RegExp(r':\d{1,2}$'), '');
    return result;
  }
}
