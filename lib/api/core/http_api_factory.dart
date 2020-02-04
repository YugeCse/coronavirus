import 'package:dio/dio.dart';

import 'http_api_manager.dart';

/// 网络Api工厂
class HttpApiFactory {
  factory HttpApiFactory._() => null;

  /// 网络请求方法
  /// + `url` 请求链接
  /// + `queryParams` 请求的Query参数
  /// + `data` 请求的Post数据参数
  /// + `cancelToken` 取消请求的Token对象
  /// + `options` 请求的一些具体请求配置
  static Future<dynamic> request(String url,
      {Map<String, dynamic> queryParams,
      data,
      CancelToken cancelToken,
      Options options}) async {
    try {
      var response = await HttpApiManager().request(url,
          queryParams: queryParams,
          data: data,
          cancelToken: cancelToken,
          options: options);
      if (response.statusCode == 200) return response.data;
      throw Exception('${response.statusCode}: 网络数据请求失败,请稍后重试!');
    } catch (e) {
      var exceptionInfo = HttpApiFactory.handleException(e);
      throw Exception('${exceptionInfo['code']}: ${exceptionInfo['message']}');
    }
  }

  /// 处理异常信息
  /// + `e` 动态异常对象
  static Map<String, dynamic> handleException(dynamic e) {
    var defaultMessage = '网络数据请求失败!';
    if (e is DioError) {
      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          return {'message': '网络连接超时!', 'code': 408};
        case DioErrorType.RECEIVE_TIMEOUT:
          return {'message': '网络数据接收超时!', 'code': 409};
        case DioErrorType.RESPONSE:
          var code = e.response?.statusCode;
          if (code == 401)
            return {'message': e.message, 'code': 401};
          else if (code == 404)
            return {'message': '请求的接口地址不存在!', 'code': 404};
          else if (code == 500)
            return {'messge': '内部服务器响错误!', 'code': 500};
          else if (code == 503) return {'messge': '服务器响应超时!', 'code': 503};
          return {'message': defaultMessage, 'code': -1};
        case DioErrorType.SEND_TIMEOUT:
          return {'message': '数据发送超时!', 'code': 400};
        case DioErrorType.CANCEL:
          return {'message': '数据请求已被取消!', 'code': -1};
        case DioErrorType.DEFAULT:
          if (e.message?.contains('SocketException: Failed host lookup') ==
              true) return {'message': '无法连接到数据地址!', 'code': -1};
          break;
      }
    }
    return {
      'message': (e is TypeError ? '数据解析失败!' : defaultMessage),
      'code': -1
    };
  }
}
