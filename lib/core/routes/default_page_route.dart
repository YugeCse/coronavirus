import 'package:flutter/cupertino.dart';

class DefaultPageRoute<T> extends PageRouteBuilder<T> {
  DefaultPageRoute({
    WidgetBuilder builder,
    Duration transitionDuration = const Duration(milliseconds: 260),
    bool opaque = true,
    bool barrierDismissible = false,
    Color barrierColor,
    String barrierLabel,
    bool maintainState = true,
  })  : assert(builder != null),
        super(
            transitionDuration: transitionDuration,
            pageBuilder: (ctx, __, ___) => builder(ctx),
            opaque: opaque,
            barrierColor: barrierColor,
            barrierLabel: barrierLabel,
            maintainState: maintainState);
}
