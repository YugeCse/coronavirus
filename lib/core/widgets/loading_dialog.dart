import 'package:flutter/material.dart';

/// 进度加载对话框视图
class LoadingDialog extends StatelessWidget {
  /// 构造函数
  /// + [message]-提示信息，默认为“拼命加载中...”
  /// + [isOutTouchDismiss]-点击透明区域是否可以取消对象框，默认为TRUE
  LoadingDialog({
    Key key,
    this.message,
    this.cancelable = true,
    this.isTouchOutsideDismiss = true,
  }) : super(key: key);

  /// 提示信息，默认为 “拼命加载中...”
  final String message;

  /// 是否可通过按钮取消返回，默认是：TRUE
  final bool cancelable;

  /// 点击透明区域是否可以取消对象框，默认为 TRUE
  final bool isTouchOutsideDismiss;

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async => (cancelable ?? true),
      child: Material(
          color: Colors.transparent,
          child: Stack(alignment: Alignment.center, children: [
            if (isTouchOutsideDismiss ?? true)
              GestureDetector(onTap: () => Navigator.of(context).pop()),
            Container(
                constraints: BoxConstraints.tightFor(width: 80, height: 80),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                      Text((message?.isNotEmpty == true) ? message : '加载中...',
                          style:
                              TextStyle(fontSize: 10, color: Color(0xff999999)))
                    ]))
          ])));
}
