import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _ChinaProvinceView_TAG =
    'com.mrper.coronavirus.widgets.china-province-view';

///中国行政区域地图控件
class ChinaProvinceView extends StatefulWidget {
  ChinaProvinceView({
    Key key,
    @required this.width,
    @required this.onViewCreated,
  })  : assert(width != null && width > 0, '地图宽度必须大于0'),
        super(key: key);

  /// 地图宽度
  final double width;
  /// 视图创建完成的事件
  final Function onViewCreated;

  @override
  _ChinaProvinceViewState createState() => _ChinaProvinceViewState();
}

class _ChinaProvinceViewState extends State<ChinaProvinceView> {
  /// 地图的宽高比例
  final double _mapWHRatio = 1369.0 / 1141.0;

  @override
  Widget build(BuildContext context) => SizedBox(
      width: widget.width,
      height: widget.width / _mapWHRatio,
      child: AndroidView(
          viewType: _ChinaProvinceView_TAG,
          creationParamsCodec: StandardMessageCodec(),
          onPlatformViewCreated: widget.onViewCreated));
}

class ChinaProvinceViewController {
  MethodChannel _methodChannel;
  EventChannel _eventChannel;

  ChinaProvinceViewController(int viewId) {
    _methodChannel = MethodChannel('$_ChinaProvinceView_TAG-$viewId');
    _eventChannel = EventChannel('$_ChinaProvinceView_TAG-$viewId-event');
  }

  /// 设置选中的背景色
  set selectedBackgroundColor(int value) => _methodChannel.invokeMethod(
      'setSelectedBackgroundColor', {'value': value ?? Colors.red.value});

  

  void dispose() {
    if (_methodChannel != null) {
      _methodChannel.setMethodCallHandler(null);
      _methodChannel = null;
    }
    if (_eventChannel != null) {
      _eventChannel = null;
    }
  }
}
