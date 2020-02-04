import 'package:dio/dio.dart';
import 'interceptor/logger_interceptor.dart';

///
/// 网络API管理类，单例实现
class HttpApiManager {
  static HttpApiManager _instance;

  static HttpApiManager _getInstance() {
    if (_instance == null) _instance = HttpApiManager._internel();
    return _instance;
  }

  Dio _dioInstance;

  factory HttpApiManager() => _getInstance();

  HttpApiManager._internel() {
    _dioInstance = Dio(BaseOptions(
        baseUrl: 'http://www.baidu.com/',
        connectTimeout: 10 * 1000,
        sendTimeout: 60 * 1000,
        receiveTimeout: 15 * 1000))
      ..interceptors
          .add(LoggerInterceptor(responseBody: true, requestBody: true));
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) =>
      _dioInstance.get(path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);

  Future<Response<T>> getUri<T>(
    Uri uri, {
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) =>
      _dioInstance.getUri(uri,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);

  Future<Response<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) =>
      _dioInstance.post(path,
          queryParameters: queryParameters,
          options: options,
          data: data,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

  Future<Response<T>> postUri<T>(
    Uri uri, {
    data,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) =>
      _dioInstance.postUri(uri,
          options: options,
          data: data,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

  Future<Response<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) =>
      _dioInstance.put(path,
          options: options,
          data: data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

  Future<Response<T>> putUri<T>(
    Uri uri, {
    data,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) =>
      _dioInstance.putUri(uri,
          options: options,
          data: data,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

  Future<Response<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
  }) =>
      _dioInstance.put(path,
          options: options,
          queryParameters: queryParameters,
          data: data,
          cancelToken: cancelToken);

  Future<Response<T>> deleteUri<T>(
    Uri uri, {
    data,
    Options options,
    CancelToken cancelToken,
  }) =>
      _dioInstance.deleteUri(uri,
          options: options, data: data, cancelToken: cancelToken);

  Future<Response<T>> request<T>(
    String path, {
    data,
    Map<String, dynamic> queryParams,
    CancelToken cancelToken,
    Options options,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) =>
      _dioInstance.request(path,
          data: data,
          queryParameters: queryParams,
          cancelToken: cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

  Future<Response<T>> requestUri<T>(
    Uri uri, {
    data,
    CancelToken cancelToken,
    Options options,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) =>
      _dioInstance.requestUri(uri,
          data: data,
          cancelToken: cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
}
