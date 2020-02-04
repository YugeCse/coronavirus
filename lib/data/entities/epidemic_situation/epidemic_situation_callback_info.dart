import 'package:coronavirus/data/entities/epidemic_situation/coronavirus_situation_info.dart';

class EpidemicSituationCallbackInfo {
  int code;

  String message;

  CornonavirusSituationInfo dataInfo;

  EpidemicSituationCallbackInfo();

  factory EpidemicSituationCallbackInfo.fromJson(Map<dynamic, dynamic> json) =>
      EpidemicSituationCallbackInfo()
        ..code = json['error'] as int
        ..message = json['message'] as String
        ..dataInfo = json['data'] != null
            ? CornonavirusSituationInfo.fromJson(json['data'])
            : null;

  Map<String, dynamic> toJson() =>
      {'code': code, 'message': message, 'data': dataInfo?.toJson()};
}
