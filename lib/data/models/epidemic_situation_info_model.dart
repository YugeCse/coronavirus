import 'package:coronavirus/data/entities/epidemic_situation/area_situation_info.dart';
import 'package:coronavirus/data/entities/epidemic_situation/coronavirus_situation_info.dart';
import 'package:coronavirus/data/entities/epidemic_situation/foreign_situation_info.dart';
import 'package:coronavirus/data/entities/epidemic_situation/situation_statistics_info.dart';
import 'package:coronavirus/data/entities/epidemic_situation/timeline_info.dart';
import 'package:flutter/material.dart';

class EpidemicSituationInfoModel extends ChangeNotifier {
  CornonavirusSituationInfo _data;
  String _locProvinceName;

  EpidemicSituationInfoModel(
      {CornonavirusSituationInfo data, String locProvinceName}) {
    _data = data;
    _locProvinceName = locProvinceName;
  }

  CornonavirusSituationInfo get data => _data;

  set data(CornonavirusSituationInfo value) {
    _data = value;
    notifyListeners();
  }

  String get locProvinceName => _locProvinceName;

  set locProvinceName(String value) {
    _locProvinceName = value;
    notifyListeners();
  }

  AreaSituationInfo get locAreaSituationInfo => _locProvinceName == null
      ? null
      : areaSituationInfoList?.singleWhere(
          (e) => _locProvinceName.contains(e.provinceShortName),
          orElse: () => null);

  SituationStatisticsInfo get statisticsInfo => _data?.statisticsInfo;

  List<AreaSituationInfo> get areaSituationInfoList =>
      _data?.areaSituationInfoList;

  List<ForeignSituationInfo> get foreignSituationInfoList =>
      _data?.foreignSituationInfoList;

  List<TimeLineInfo> get timelineInfoList => _data?.timelineInfoList;
}
