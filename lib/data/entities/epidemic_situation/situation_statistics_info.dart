class SituationStatisticsInfo {
  int id;

  int createTime;

  int modifyTime;

  String imgUrl;

  String dailyPic;

  List<String> dailyPics;

  String summary;

  bool deleted;

  String countRemark;

  int confirmedCount;

  int suspectedCount;

  int curedCount;

  int seriousCount;

  int deadCount;

  int suspectedIncr;

  int confirmedIncr;

  int curedIncr;

  int deadIncr;

  int seriousIncr;

  String remark1;

  String remark2;

  String remark3;

  String remark4;

  String remark5;

  String note1;

  String note2;

  String note3;

  String generalRemark;

  String abroadRemark;

  SituationStatisticsInfo();

  factory SituationStatisticsInfo.fromJson(Map<dynamic, dynamic> json) =>
      SituationStatisticsInfo()
        ..id = json['id'] as int
        ..createTime = json['createTime'] as int
        ..modifyTime = json['modifyTime'] as int
        ..imgUrl = json['imgUrl'] as String
        ..dailyPic = json['dailyPic'] as String
        ..dailyPics = json['dailyPics'] != null && json['dailyPics'] is List
            ? (json['dailyPics'] as List).map((e) => e as String).toList()
            : null
        ..summary = json['summary'] as String
        ..deleted = json['deleted'] as bool
        ..countRemark = json['countRemark'] as String
        ..confirmedCount = json['confirmedCount'] as int
        ..suspectedCount = json['suspectedCount'] as int
        ..curedCount = json['curedCount'] as int
        ..seriousCount = json['seriousCount'] as int
        ..deadCount = json['deadCount'] as int
        ..suspectedIncr = json['suspectedIncr'] as int
        ..confirmedIncr = json['confirmedIncr'] as int
        ..curedIncr = json['curedIncr'] as int
        ..deadIncr = json['deadIncr'] as int
        ..seriousIncr = json['seriousIncr'] as int
        ..remark1 = json['remark1'] as String
        ..remark2 = json['remark2'] as String
        ..remark3 = json['remark3'] as String
        ..remark4 = json['remark4'] as String
        ..remark5 = json['remark5'] as String
        ..note1 = json['note1'] as String
        ..note2 = json['note2'] as String
        ..note3 = json['note3'] as String
        ..generalRemark = json['generalRemark'] as String
        ..abroadRemark = json['abroadRemark'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'createTime': createTime,
        'modifyTime': modifyTime,
        'imgUrl': imgUrl,
        'dailyPic': dailyPic,
        'dailyPics': dailyPics,
        'summary': summary,
        'deleted': deleted,
        'countRemark': countRemark,
        'confirmedCount': confirmedCount,
        'suspectedCount': suspectedCount,
        'curedCount': curedCount,
        'seriousCount': seriousCount,
        'deadCount': deadCount,
        'suspectedIncr': suspectedIncr,
        'confirmedIncr': confirmedIncr,
        'curedIncr': curedIncr,
        'deadIncr': deadIncr,
        'seriousIncr': seriousIncr,
        'remark1': remark1,
        'remark2': remark2,
        'remark3': remark3,
        'remark4': remark4,
        'remark5': remark5,
        'note1': note1,
        'note2': note2,
        'note3': note3,
        'generalRemark': generalRemark,
        'abroadRemark': abroadRemark
      };
}
