import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

/// 经典的加载视图
class ClassicalLoadingView extends StatelessWidget {
  final Color progressIndicatorColor;
  final String progressText;
  final Color progressTextColor;

  ClassicalLoadingView({
    Key key,
    this.progressText = '正在拼命加载中...',
    this.progressTextColor = const Color(0xff999999),
    this.progressIndicatorColor,
  })  : assert(progressText != null && progressText.isNotEmpty,
            '参数：[progressText]不能为Null或空字符串'),
        assert(progressTextColor != null, '参数：[progressTextColor]不能为Null'),
        super(key: key);

  @override
  Widget build(BuildContext context) => Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            SizedBox(
                width: 80,
                height: 80,
                child: FlareActor('assets/flares/virus.flr',
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    color: Colors.red,
                    animation: 'virus_rotate')),
            // CircularProgressIndicator(
            //     valueColor: AlwaysStoppedAnimation(
            //         progressIndicatorColor ?? Theme.of(context).accentColor)),
            Padding(
                padding: const EdgeInsets.only(top: 35),
                child: Text(progressText,
                    style: TextStyle(fontSize: 12, color: progressTextColor)))
          ]));
}
