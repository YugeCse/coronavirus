import 'package:coronavirus/api/api_uril.dart';
import 'package:coronavirus/api/core/http_api_factory.dart';
import 'package:coronavirus/data/entities/epidemic_situation/epidemic_situation_callback_info.dart';

class HttpApiRepositories {
  factory HttpApiRepositories._() => null;

  static Future<EpidemicSituationCallbackInfo> getCoronavirusSituationInfo() async {
    try {
      return EpidemicSituationCallbackInfo.fromJson(
          await HttpApiFactory.request(ApiUrl.coronavirusSituationInfo));
    } on Exception catch (e) {
      var errorInfos = e.toString().split(':');
      return EpidemicSituationCallbackInfo()
        ..code = int.tryParse(errorInfos[0].toString())
        ..message = errorInfos[1]?.toString()?.trim();
    }
  }
}
