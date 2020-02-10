import 'dart:ui' as UI;
import 'package:coronavirus/utils/graphics/path_parser.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as Xml;

/// 地图区域选择变化事件
typedef void OnSelectedAreaChanged(AreaInfo info, double mapScale);

/// 地图视图
class MapView extends StatefulWidget {
  MapView({
    Key key,
    @required this.mapInfo,
    @required this.width,
    @required this.selectedBackgroundColor,
    this.backgroundRenderParams,
    this.onSelectedAreaChanged,
  })  : assert(mapInfo != null),
        assert(width != null && width > 0),
        super(key: key);

  /// 地图数据
  final MapInfo mapInfo;

  /// 地图宽度，高度根据高度自动缩放
  final double width;

  /// 被选中的颜色
  final Color selectedBackgroundColor;

  ///地图渲染参数
  final Map<String, Color> backgroundRenderParams;

  ///选择的地区变化的事件
  final OnSelectedAreaChanged onSelectedAreaChanged;

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  double _mapScale = 1.0; //地图缩放率
  double _mapRatio; //地图W/H比例
  MapInfo _mapInfo; //地图信息

  void _initializer() {
    _mapInfo = widget.mapInfo;
    _mapScale = widget.width / _mapInfo.width;
    _mapRatio = _mapInfo.width / _mapInfo.height;
    _mapInfo.areaInfoList.forEach((e) {
      if (widget.backgroundRenderParams?.containsKey(e.name) == true)
        e.backgroundColor = widget.backgroundRenderParams[e.name];
      e.selectedBackgroundColor = widget.selectedBackgroundColor;
    });
  }

  void _onMapViewClick(TapDownDetails details) {
    AreaInfo originalselectedAreaInfo, currentSelectedAreaInfo;
    _mapInfo?.areaInfoList?.forEach((e) {
      if (e.isSelected) originalselectedAreaInfo = e;
      if (e.isTouched(Offset(details.localPosition.dx / _mapScale,
          details.localPosition.dy / _mapScale))) {
        currentSelectedAreaInfo = e;
        e.isSelected = true;
      }
    });
    if (originalselectedAreaInfo != currentSelectedAreaInfo) {
      originalselectedAreaInfo?.isSelected = false;
      currentSelectedAreaInfo?.isSelected = true;
      if (widget.onSelectedAreaChanged != null)
        widget.onSelectedAreaChanged(currentSelectedAreaInfo, _mapScale);
    }
    setState(() {});
  }

  @override
  void initState() {
    _initializer();
    super.initState();
  }

  @override
  void didUpdateWidget(MapView oldWidget) {
    if (oldWidget.backgroundRenderParams != widget.backgroundRenderParams) {
      _mapInfo.areaInfoList.forEach((e) {
        if (widget.backgroundRenderParams?.containsKey(e.name) == true)
          e.backgroundColor = widget.backgroundRenderParams[e.name];
        e.selectedBackgroundColor = widget.selectedBackgroundColor;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTapDown: (details) => _onMapViewClick(details),
      child: _mapInfo == null ? Container() : _buildContentView());

  Widget _buildContentView() => CustomPaint(
      painter: _MapPainter(_mapScale, _mapInfo.areaInfoList),
      size: Size(widget.width, widget.width / _mapRatio));
}

class _MapPainter extends CustomPainter {
  _MapPainter(this.mapScale, this.areaInfoList);

  final double mapScale;
  final List<AreaInfo> areaInfoList;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(mapScale, mapScale);
    if (areaInfoList?.isEmpty ?? true) return;
    areaInfoList
      ..forEach((info) => info.drawPath(canvas))
      ..forEach((info) => info.drawPath(canvas, isFill: false))
      ..forEach((info) => info.drawName(canvas, mapScale));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

/// 地图信息
class MapInfo {
  /// 地图宽度
  double width;

  /// 地图高度
  double height;

  /// 区域信息
  List<AreaInfo> areaInfoList;
}

/// 区域信息实体类
class AreaInfo {
  /// 名称
  String name;

  /// 描边线的宽度，默认为1.0
  double borderWith = 1.0;

  /// 描边线的颜色，默认为[Colors.black]
  Color borderColor = Colors.black;

  /// 背景色,默认为[Colors.transparent]
  Color backgroundColor = Colors.transparent;

  /// 选中后的背景色，默认为[Colors.blue]
  Color selectedBackgroundColor = Colors.blue;

  /// 文本颜色， 默认为[Colors.black]
  Color textColor = Colors.black;

  /// 文本大小，默认为11.0
  double textSize = 9.0;

  /// 是否被选中，默认为[false]
  bool isSelected = false;

  /// 绘制的路径
  Path path;

  /// 路径范围
  Rect get bounds => path.getBounds();

  AreaInfo();

  /// 是否被点击
  bool isTouched(Offset offset) => path?.contains(offset) ?? false;

  /// 路径绘制
  void drawPath(Canvas canvas, {bool isFill = true}) {
    Paint paint = Paint()..isAntiAlias = true;
    if (isFill) {
      paint.style = PaintingStyle.fill;
      paint.color = isSelected ? selectedBackgroundColor : backgroundColor;
    } else {
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = borderWith;
      paint.color = borderColor;
    }
    canvas.drawPath(path, paint);
  }

  /// 名称绘制
  void drawName(Canvas canvas, double mapScale) {
    UI.ParagraphBuilder paragraphBuilder =
        UI.ParagraphBuilder(UI.ParagraphStyle(fontSize: textSize / mapScale))
          ..pushStyle(UI.TextStyle(color: textColor))
          ..addText(name);
    UI.Paragraph paragraph = paragraphBuilder.build()
      ..layout(UI.ParagraphConstraints(width: double.infinity));
    canvas.drawParagraph(paragraph, _getDrawNameOffset(paragraph));
  }

  Offset _getDrawNameOffset(UI.Paragraph paragraph) {
    double x = bounds.center.dx - 25,
        y = bounds.center.dy - paragraph.height / 2;
    switch (name) {
      case '甘肃':
        x = bounds.right - bounds.width * 0.38;
        y = bounds.bottom - bounds.height * 0.3;
        break;
      case '内蒙古':
        y = bounds.bottom - bounds.height * 0.3;
        break;
      case '陕西':
        y = bounds.bottom - bounds.height * 0.38;
        break;
      case '广东':
        y = bounds.top + bounds.height * 0.18;
        break;
      case '香港':
        x = bounds.right + 10;
        break;
      case '澳门':
        y = bounds.bottom + 5;
        break;
      case '上海':
        x = bounds.right;
        break;
      case '安徽':
        y = bounds.center.dy + 5;
        break;
      case '江苏':
        x = bounds.center.dx + 3;
        break;
      case '河北':
        x = bounds.left + 8;
        y = bounds.bottom - bounds.height * 0.45;
        break;
      case '北京':
        y -= 25;
        break;
      case '天津':
        x = bounds.right;
        break;
      case '黑龙江':
        y = bounds.bottom - bounds.height * 0.45;
        break;
      case '山西':
        x -= 10;
        break;
      case '江西':
      case '山东':
        x -= 25;
        break;
      case '福建':
        x -= 15;
        break;
      case '辽宁':
        y -= 18;
        break;
      case '云南':
        y += 18;
        break;
    }
    return Offset(x, y);
  }
}

/// 通过Vector资源获取地图数据
Future<MapInfo> getMapInfoByVectorXmlAsset(
    BuildContext context, String assetName) async {
  MapInfo mapInfo = MapInfo();
  String assetContent =
      await DefaultAssetBundle.of(context).loadString(assetName);
  Xml.XmlDocument xmlDocument = Xml.parse(assetContent);
  xmlDocument.children.forEach((node) {
    if (node is Xml.XmlElement && node.name.qualified == 'vector') {
      mapInfo
        ..width = double.parse(node.getAttribute('android:viewportWidth'))
        ..height = double.parse(node.getAttribute('android:viewportHeight'))
        ..areaInfoList = List();
      node.children.forEach((pathNode) {
        if (pathNode is Xml.XmlElement && pathNode.name.qualified == 'path') {
          String borderColor = pathNode.getAttribute('android:strokeColor');
          String backgroundColor = pathNode.getAttribute('android:fillColor');
          AreaInfo areaInfo = AreaInfo()
            ..name = pathNode.getAttribute('android:name')
            ..borderWith =
                double.parse(pathNode.getAttribute('android:strokeWidth'))
            ..path = PathParser.createPathFromPathData(
                pathNode.getAttribute('android:pathData'));
          if (borderColor != 'none') {
            int length = borderColor.length;
            areaInfo.borderColor = Color(int.parse(
                borderColor.replaceFirst('#', '0x${length == 9 ? '' : 'FF'}')));
          }
          if (backgroundColor != 'none') {
            int length = borderColor.length;
            areaInfo.backgroundColor = Color(int.parse(backgroundColor
                .replaceFirst('#', '0x${length == 9 ? '' : 'FF'}')));
          }
          mapInfo.areaInfoList.add(areaInfo);
        }
      });
    }
  });
  return mapInfo;
}
