import 'package:flutter/services.dart';

class GeoLocation {
  factory GeoLocation._() => null;

  static const MethodChannel _methodChannel =
      const MethodChannel('com.mrper.coronavirus.plugins.location-plugin');

  /// 获取定位信息
  static Future<LocationInfo> getLocationInfo([int scanSpanTime = 0]) async =>
      LocationInfo.fromJson(await _methodChannel
          .invokeMethod('getLocationInfo', {'scanSpanTime': scanSpanTime}));
}

class LocationInfo {
  String province;

  String address;

  double longitude;

  double latitude;

  LocationInfo();

  factory LocationInfo.fromJson(Map<dynamic, dynamic> json) => LocationInfo()
    ..province = json['province'] as String
    ..address = json['address'] as String
    ..longitude = json['longitude'] as double
    ..latitude = json['latitude'] as double;

  Map<String, dynamic> toJson() => {
        'province': province,
        'address': address,
        'longitude': longitude,
        'latitude': latitude
      };
}
