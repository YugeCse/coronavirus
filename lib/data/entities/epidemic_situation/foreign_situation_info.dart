class ForeignSituationInfo {
  String id;

  String name;

  String shortName;

  String tags;

  int confirmed;

  int suspected;

  int cured;

  int dead;

  String comment;

  int createTime;

  int modifyTime;

  ForeignSituationInfo();

  factory ForeignSituationInfo.fromJson(Map<dynamic, dynamic> json) =>
      ForeignSituationInfo()
        ..id = json['id'] as String
        ..name = json['name'] as String
        ..shortName = json['shortName'] as String
        ..confirmed = json['confirmed'] as int
        ..suspected = json['suspected'] as int
        ..cured = json['cured'] as int
        ..dead = json['dead'] as int
        ..comment = json['comment'] as String
        ..createTime = json['createTime'] as int
        ..modifyTime = json['modifyTime'] as int;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'shortName': shortName,
        'confirmed': confirmed,
        'suspected': suspected,
        'cured': cured,
        'dead': dead,
        'comment': comment,
        'createTime': createTime,
        'modifyTime': modifyTime
      };
}
