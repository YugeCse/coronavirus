class AreaSituationInfo {
  String provinceName;

  String provinceShortName;

  int confirmed;

  int suspected;

  int cured;

  int dead;

  String comment;

  List<CitySituationInfo> cityInfoList;

  AreaSituationInfo();

  factory AreaSituationInfo.fromJson(Map<dynamic, dynamic> json) =>
      AreaSituationInfo()
        ..provinceName = json['provinceName'] as String
        ..provinceShortName = json['provinceShortName'] as String
        ..confirmed = json['confirmed'] as int
        ..suspected = json['suspected'] as int
        ..cured = json['cured'] as int
        ..dead = json['dead'] as int
        ..comment = json['comment'] as String
        ..cityInfoList = json['cities'] != null && json['cities'] is List
            ? (json['cities'] as List)
                .map((e) => CitySituationInfo.fromJson(e))
                .toList()
            : null;

  Map<String, dynamic> toJson() => {
        'provinceName': provinceName,
        'provinceShortName': provinceShortName,
        'confirmed': confirmed,
        'suspected': suspected,
        'cured': cured,
        'dead': dead,
        'comment': comment,
        'cities': cityInfoList?.map((e) => e.toJson())?.toList()
      };
}

class CitySituationInfo {
  String cityName;

  int confirmed;

  int suspected;

  int cured;

  int dead;

  CitySituationInfo();

  factory CitySituationInfo.fromJson(Map<dynamic, dynamic> json) =>
      CitySituationInfo()
        ..cityName = json['cityName'] as String
        ..confirmed = json['confirmed'] as int
        ..suspected = json['suspected'] as int
        ..cured = json['cured'] as int
        ..dead = json['dead'] as int;

  Map<String, dynamic> toJson() => {
        'cityName': cityName,
        'confirmed': confirmed,
        'suspected': suspected,
        'cured': cured,
        'dead': dead
      };
}
