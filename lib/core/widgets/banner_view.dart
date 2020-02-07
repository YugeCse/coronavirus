import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

typedef BannerViewItemBuilder = Widget Function(
    BuildContext context, int postion, int realPosition, dynamic itemData);

class BannerView<T> extends StatefulWidget {
  BannerView({
    Key key,
    double width,
    double height = 210,
    @required this.dataSource,
    @required BannerViewItemBuilder itemBuilder,
    Duration duration,
  })  : assert(height != null && height > 0, '高度不能小于0'),
        assert(dataSource?.isNotEmpty == true, '数据源不能为空'),
        width = width,
        height = height,
        virutalDataSource = dataSource?.isNotEmpty == true
            ? [dataSource[dataSource.length - 1], ...dataSource, dataSource[0]]
            : throw Exception('数据源不能为空'),
        duration = duration ?? const Duration(seconds: 5),
        itemBuilder = itemBuilder,
        super(key: key);

  final double width;
  final double height;
  final List<String> dataSource;
  final List<String> virutalDataSource;
  final Duration duration;
  final BannerViewItemBuilder itemBuilder;

  @override
  _BannerViewState createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView>
    with SingleTickerProviderStateMixin {
  PageController _pageController;
  int _virtualPosition = 1, _position = 0, _indicatorPosition = 0;
  Timer _timer; //动画定时器

  /// 初始化
  void _initializer() {
    _pageController = PageController(initialPage: 1)
      ..addListener(_onListenScrollOffsetChanged);
    _initAndStartTimer(); //初始化并启动动画定时器
  }

  /// 获取真实的索引位置
  /// + `pagePosition` virtual的Page索引位置
  int _getRealPagePosition(int pagePosition) {
    if (pagePosition == widget.virutalDataSource.length - 1)
      pagePosition = 1;
    else if (pagePosition == 0)
      pagePosition = widget.virutalDataSource.length - 2;
    else
      pagePosition -= 1;
    return pagePosition;
  }

  /// 监听滚动的Offset的变化
  void _onListenScrollOffsetChanged() {
    final Decimal curPageOffset =
        Decimal.parse(_pageController.offset.toString()) /
            Decimal.parse(
                (widget.width ?? MediaQuery.of(context).size.width).toString());
    //设置indicator所在的位置
    setState(() => _indicatorPosition =
        _getRealPagePosition(curPageOffset.toDouble().round()));
    final curPageInt = int.tryParse(curPageOffset.toString());
    if (curPageInt != null) {
      _virtualPosition = curPageInt;
      //设置Page的逻辑位置
      setState(() => _position = _getRealPagePosition(curPageInt));
      if (curPageInt == 0)
        _pageController.jumpToPage(_position);
      else if (curPageInt == widget.virutalDataSource.length - 1)
        _pageController.jumpToPage(_position);
    }
  }

  @override
  void initState() {
    _initializer();
    super.initState();
  }

  @override
  void dispose() {
    _releaseTimer();
    _pageController
      ..removeListener(_onListenScrollOffsetChanged)
      ..dispose();
    super.dispose();
  }

  /// 初始化并启动定时器
  void _initAndStartTimer() {
    _releaseTimer();
    _timer = Timer.periodic(widget.duration, (_) {
      _pageController.animateToPage(++_virtualPosition,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutQuart);
    });
  }

  /// 释放定时器
  void _releaseTimer() {
    if (_timer != null) _timer.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) =>
      Stack(alignment: Alignment.bottomCenter, children: [
        GestureDetector(
            onTapDown: (_) => _releaseTimer(),
            onTapUp: (_) => _initAndStartTimer(),
            onTapCancel: () => _initAndStartTimer(),
            child: SizedBox(
                width: widget.width,
                height: widget.height,
                child: PageView.builder(
                  controller: _pageController,
                  pageSnapping: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: widget.virutalDataSource?.length ?? 0,
                  itemBuilder: (context, position) => widget.itemBuilder(
                      context,
                      position,
                      position == widget.virutalDataSource.length - 1
                          ? 0
                          : (position == 0
                              ? widget.virutalDataSource.length - 2
                              : position - 1),
                      widget.virutalDataSource.elementAt(position)),
                ))),
        _buildIndicator()
      ]);

  /// 构建指示器
  Widget _buildIndicator() => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < widget.dataSource.length; i++)
              Container(
                  height: 5,
                  width: 5,
                  margin: EdgeInsets.only(left: i == 0 ? 0 : 8),
                  decoration: BoxDecoration(
                      color: _indicatorPosition == i
                          ? Colors.blue
                          : Colors.grey[500],
                      borderRadius: BorderRadius.all(Radius.circular(1000))))
          ]));
}
