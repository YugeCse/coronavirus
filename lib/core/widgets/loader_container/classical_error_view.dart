import 'package:flutter/material.dart';

import '../rounded_button.dart';

/// 经典的错误视图
class ClassicalErrorView extends StatelessWidget {
  ClassicalErrorView({
    Key key,
    this.imagePath,
    double imageWidth = 120,
    double imageHeight = 120,
    Size imageSize,
    double spacingFromImageToText = 80,
    this.messageText = '加载失败，请稍后点击重试',
    this.messageTextColor = const Color(0xff999999),
    double messageTextSize = 12,
    this.buttonText = '重新加载',
    this.buttonTextColor = Colors.white,
    double buttonTextSize = 14,
    this.buttonBackgroundColor,
    double buttonWidth = 120,
    double buttonHeight = 35,
    Size buttonSize,
    this.buttonBorderRadius = const BorderRadius.all(Radius.circular(5)),
    double spacingFromTextToButton = 35,
    this.onReload,
  })  : assert(messageText != null && messageText.isNotEmpty,
            '参数：[messageText]不能为Null或空字符串'),
        assert(messageTextColor != null, '参数：[messageTextColor]不能为Null'),
        assert(buttonText != null && buttonText.isNotEmpty,
            '参数：[buttonText]不能为Null或空字符串'),
        assert(buttonTextColor != null, '参数：[buttonTextColor]不能为Null'),
        assert(buttonSize != null ||
            (buttonWidth != null && buttonHeight != null)),
        imageSize = imageSize ?? Size(imageWidth, imageHeight),
        spacingFromImageToText = spacingFromImageToText ?? 80,
        messageTextSize = messageTextSize ?? 12,
        buttonTextSize = buttonTextSize ?? 14,
        spacingFromTextToButton = spacingFromTextToButton ?? 35,
        buttonSize = buttonSize ?? Size(buttonWidth, buttonHeight),
        super(key: key);

  /// 图片路径，否则使用默认图
  final String imagePath;

  /// 图片大小，默认为：width-80, height-80
  final Size imageSize;

  /// 图片到文本的间距，默认为：12
  final double spacingFromImageToText;

  /// 消息文本文字，默认为：加载失败，请稍后点击重试
  final String messageText;

  /// 消息文本颜色，默认为：#999999
  final Color messageTextColor;

  /// 消息文本大小，默认为：12
  final double messageTextSize;

  /// 按钮文本，默认为：重新加载
  final String buttonText;

  /// 按钮文本大小，默认为：14
  final double buttonTextSize;

  /// 按钮文本色，默认为：白色
  final Color buttonTextColor;

  /// 按钮背景色，默认为：主题色
  final Color buttonBackgroundColor;

  /// 按钮大小，默认为：width-100,height-35
  final Size buttonSize;

  /// 按钮的BorderRadius
  final BorderRadius buttonBorderRadius;

  /// 文本信息到按钮的间距，默认为：35
  final double spacingFromTextToButton;

  /// 重新加载事件函数
  final Function onReload;

  @override
  Widget build(BuildContext context) => Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Image.asset('assets/images/ic_default_load_data_failed.png',
                width: imageSize.width, height: imageSize.height),
            Padding(
                padding: EdgeInsets.only(top: spacingFromImageToText),
                child: Text(messageText,
                    style: TextStyle(
                        fontSize: messageTextSize, color: messageTextColor))),
            if (onReload != null)
              RoundedButton(
                  width: buttonSize.width,
                  height: buttonSize.height,
                  color: buttonBackgroundColor ?? Theme.of(context).accentColor,
                  margin: EdgeInsets.only(top: spacingFromTextToButton),
                  borderRadius: buttonBorderRadius,
                  onPressed: onReload,
                  child: Text(buttonText,
                      style: TextStyle(
                          color: buttonTextColor, fontSize: buttonTextSize)))
          ]));
}
