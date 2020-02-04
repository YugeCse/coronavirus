import 'area_situation_info.dart';
import 'foreign_situation_info.dart';
import 'readme_info.dart';
import 'situation_statistics_info.dart';
import 'timeline_info.dart';

/// 冠状病毒实情信息
class CornonavirusSituationInfo {
  /// ReadMe-说明
  ReadMeInfo readmeInfo;

  /// 统计信息
  SituationStatisticsInfo statisticsInfo;

  /// 国内状况信息列表
  List<AreaSituationInfo> areaSituationInfoList;

  /// 国外状况信息列表
  List<ForeignSituationInfo> foreignSituationInfoList;

  /// 相关新闻的列表
  List<TimeLineInfo> timelineInfoList;

  CornonavirusSituationInfo();

  factory CornonavirusSituationInfo.fromJson(Map<dynamic, dynamic> json) =>
      CornonavirusSituationInfo()
        ..readmeInfo =
            json['readme'] != null ? ReadMeInfo.fromJson(json['readme']) : null
        ..statisticsInfo = json['statistics'] != null
            ? SituationStatisticsInfo.fromJson(json['statistics'])
            : null
        ..areaSituationInfoList =
            json['listByArea'] != null && json['listByArea'] is List
                ? (json['listByArea'] as List)
                    .map((e) => AreaSituationInfo.fromJson(e))
                    .toList()
                : null
        ..foreignSituationInfoList =
            json['listByOther'] != null && json['listByOther'] is List
                ? (json['listByOther'] as List)
                    .map((e) => ForeignSituationInfo.fromJson(e))
                    .toList()
                : null
        ..timelineInfoList =
            json['timeline'] != null && json['timeline'] is List
                ? (json['timeline'] as List)
                    .map((e) => TimeLineInfo.fromJson(e))
                    .toList()
                : null;

  Map<String, dynamic> toJson() => {
        'readme': readmeInfo?.toJson(),
        'listByArea': areaSituationInfoList?.map((e) => e.toJson())?.toList(),
        'listByOther':
            foreignSituationInfoList?.map((e) => e.toJson())?.toList(),
        'timeline': timelineInfoList?.map((e) => e.toJson())?.toList()
      };
}
