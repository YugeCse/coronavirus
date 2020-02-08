import 'dart:ui' as UI;
import 'package:coronavirus/utils/graphics/path_parser.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as Xml;

class MapView extends StatefulWidget {
  MapView({
    Key key,
    @required this.vectorAssetName,
    @required this.width,
    @required this.selectedBackgroundColor,
  })  : assert(vectorAssetName != null),
        assert(width != null && width > 0),
        super(key: key);

  /// Vector资源路径名称
  final String vectorAssetName;

  /// 地图宽度，高度根据高度自动缩放
  final double width;

  /// 被选中的颜色
  final Color selectedBackgroundColor;

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  double _mapScale = 1.0; //地图缩放率
  double _mapRatio; //地图W/H比例
  MapInfo _mapInfo; //地图信息
  Map<String, Color> _backgroundRenderParams; //地图渲染参数

  void _initializer() {
    Future.microtask(() async {
      var result = await _parseVectorXmlAsset(context, widget.vectorAssetName);
      setState(() {
        _mapScale = widget.width / result.width;
        _mapRatio = result.width / result.height;
        _mapInfo = result
          ..areaInfoList.forEach((e) {
            if (_backgroundRenderParams?.containsKey(e.name) == true)
              e.backgroundColor = _backgroundRenderParams[e.name];
            e.selectedBackgroundColor = widget.selectedBackgroundColor;
          });
      });
    });
  }

  void setProvincesColors(Map<String, Color> params) =>
      _backgroundRenderParams = params;

  @override
  void initState() {
    _initializer();
    super.initState();
  }

  @override
  void didUpdateWidget(MapView oldWidget) {
    _mapInfo?.areaInfoList?.forEach((e) {
      if (_backgroundRenderParams?.containsKey(e.name) == true)
        e.backgroundColor = _backgroundRenderParams[e.name];
      e.selectedBackgroundColor = widget.selectedBackgroundColor;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTapDown: (details) {
        _mapInfo?.areaInfoList?.forEach((e) => e.isSelected = e.isTouched(
            Offset(details.localPosition.dx / _mapScale,
                details.localPosition.dy / _mapScale)));
        setState(() {});
      },
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
        y = bounds.bottom - bounds.height * 0.4;
        break;
      case '北京':
        y = bounds.top - paragraph.height + 5;
        break;
      case '天津':
        x = bounds.right;
        break;
    }
    return Offset(x, y);
  }
}

Future<MapInfo> _parseVectorXmlAsset(
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
