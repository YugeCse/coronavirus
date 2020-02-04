class ReadMeInfo {
  String statistics;

  String listByArea;

  String listByOther;

  String timeline;

  String listByCountry;

  ReadMeInfo();

  factory ReadMeInfo.fromJson(Map<dynamic, dynamic> json) => ReadMeInfo()
    ..statistics = json['statistics'] as String
    ..listByArea = json['listByArea'] as String
    ..listByOther = json['listByOther'] as String
    ..timeline = json['timeline'] as String
    ..listByCountry = json['listByCountry'] as String;

  Map<String, dynamic> toJson() => {
        'statistics': statistics,
        'listByArea': listByArea,
        'listByOther': listByOther,
        'timeline': timeline,
        'listByCountry': listByCountry
      };
}
