class TimeLineInfo {
  int id;

  int pubDate;

  String pubDateStr;

  String title;

  String summary;

  String infoSource;

  String sourceUrl;

  String provinceId;

  String provinceName;

  int createTime;

  int modifyTime;

  int entryWay;

  int adoptType;

  int infoType;

  int dataInfoState;

  String dataInfoOperator;

  int dataInfoTime;

  TimeLineInfo();

  factory TimeLineInfo.fromJson(Map<dynamic, dynamic> json) => TimeLineInfo()
    ..id = json['id'] as int
    ..pubDate = json['pubDate'] as int
    ..pubDateStr = json['pubDateStr'] as String
    ..title = json['title'] as String
    ..summary = json['summary'] as String
    ..infoSource = json['infoSource'] as String
    ..sourceUrl = json['sourceUrl'] as String
    ..provinceId = json['provinceId'] as String
    ..provinceName = json['provinceName'] as String
    ..createTime = json['createTime'] as int
    ..modifyTime = json['modifyTime'] as int
    ..entryWay = json['entryWay'] as int
    ..adoptType = json['adoptType'] as int
    ..infoType = json['infoType'] as int
    ..dataInfoState = json['dataInfoState'] as int
    ..dataInfoOperator = json['dataInfoOperator'] as String
    ..dataInfoTime = json['dataInfoTime'] as int;

  Map<String, dynamic> toJson() => {
        'id': id,
        'pubDate': pubDate,
        'pubDateStr': pubDateStr,
        'title': title,
        'summary': summary,
        'infoSource': infoSource,
        'sourceUrl': sourceUrl,
        'provinceId': provinceId,
        'provinceName': provinceName,
        'createTime': createTime,
        'modifyTime': modifyTime,
        'entryWay': entryWay,
        'adoptType': adoptType,
        'dataInfoState': dataInfoState,
        'dataInfoOperator': dataInfoOperator,
        'dataInfoTime': dataInfoTime
      };
}
