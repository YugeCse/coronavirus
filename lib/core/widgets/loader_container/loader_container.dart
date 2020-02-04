import 'package:flutter/material.dart';

import 'classical_error_view.dart';
import 'classical_loading_view.dart';
import 'classical_no_data_view.dart';

/// 加载容器
class LoaderContainer extends StatelessWidget {
  LoaderContainer({
    Key key,
    @required this.state,
    @required this.onReload,
    @required this.contentView,
    this.loadingView,
    this.errorView,
    this.emptyView,
  })  : assert(onReload != null, '参数：[onReload]不能为Null'),
        assert(contentView != null, '参数：[contentView]不能为Null'),
        super(key: key);

  final LoaderState state;
  final Widget loadingView;
  final Widget errorView;
  final Widget emptyView;
  final Widget contentView;
  final Function onReload;

  @override
  Widget build(BuildContext context) {
    Widget currentWidget;
    switch (state) {
      case LoaderState.Succeed:
      case LoaderState.NoAction:
        currentWidget = contentView;
        break;
      case LoaderState.NoData:
        currentWidget = emptyView ?? ClassicalNoDataView(onRefresh: onReload);
        break;
      case LoaderState.Error:
        currentWidget = errorView ?? ClassicalErrorView(onReload: onReload);
        break;
      case LoaderState.Loading:
      default:
        currentWidget = loadingView ?? ClassicalLoadingView();
    }
    return currentWidget;
  }
}

/// 加载状态
enum LoaderState {
  /// 无状态
  NoAction,

  /// 正在加载
  Loading,

  /// 加载成功
  Succeed,

  /// 加载出错
  Error,

  /// 无数据
  NoData
}
