import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Fade效果的动画参数(primary)
final Tween<double> _tweenFade = Tween<double>(begin: 0, end: 1.0);

/// 动画效果从底部到顶部的参数(primary)
final Tween<Offset> _primaryTweenSlideFromBottomToTop =
    Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero);

// final Tween<Offset> _secondaryTweenSlideFromBottomToTop =
//     Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, -1.0));

/// 动画效果从顶部到底部的参数(primary)
final Tween<Offset> _primaryTweenSlideFromTopToBottom =
    Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero);

// final Tween<Offset> _secondaryTweenSlideFromTopToBottom =
//     Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 1.0));

/// 动画效果从右边到左边的参数(primary)
final Tween<Offset> _primaryTweenSlideFromRightToLeft =
    Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero);

/// 动画效果从右边到左边的参数(secondary)
final Tween<Offset> _secondaryTweenSlideFromRightToLeft =
    Tween<Offset>(begin: Offset.zero, end: const Offset(-1.0, 0.0));

/// 动画效果从左边到右边的参数(primary)
final Tween<Offset> _primaryTweenSlideFromLeftToRight =
    Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero);

/// 动画效果从左边到右边的参(secondary)
final Tween<Offset> _secondaryTweenSlideFromLeftToRight =
    Tween<Offset>(begin: Offset.zero, end: const Offset(1.0, 0.0));

/// 动画类型枚举，`SlideRL`,`SlideLR`,`SlideTB`, `SlideBT`, `Fade`
enum AnimationType {
  /// 从右到左的滑动
  SlideRightToLeft,

  /// 从左到右的滑动
  SlideLeftToRight,

  /// 从上到下的滑动
  SlideTopToBottom,

  /// 从下到上的滑动
  SlideBottomToTop,

  /// 透明过渡
  Fade,
}

/// 动画路由
class AnimationPageRoute<T> extends PageRoute<T> {
  AnimationPageRoute({
    @required this.builder,
    this.isExitPageAffectedOrNot = true,
    this.animationType = AnimationType.SlideRightToLeft,
    this.animationDuration = const Duration(milliseconds: 450),
    RouteSettings settings,
    this.maintainState = true,
    bool fullscreenDialog = false,
  })  : assert(builder != null),
        assert(isExitPageAffectedOrNot != null),
        assert(animationType != null &&
            [AnimationType.SlideRightToLeft, AnimationType.SlideLeftToRight]
                .contains(animationType)),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        assert(opaque),
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  /// 页面构造
  final WidgetBuilder builder;

  /// 当前页面是否有动画，默认为：`TRUE`，
  /// 注意：当[AnimationType]为[SlideLeftToRight]或[SlideRightToLeft]，新页面及当前页面动画均有效
  final bool isExitPageAffectedOrNot;

  /// 动画类型
  final AnimationType animationType;

  final Duration animationDuration;

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration =>
      animationDuration ?? const Duration(milliseconds: 450);

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) =>
      nextRoute is AnimationPageRoute && !nextRoute.fullscreenDialog;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final Widget result = builder(context);
    assert(() {
      if (result == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'The builder for route "${settings.name}" returned null.'),
          ErrorDescription('Route builders must never return null.')
        ]);
      }
      return true;
    }());
    return Semantics(
        scopesRoute: true, explicitChildNodes: true, child: result);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final Curve curve = Curves.linear, reverseCurve = Curves.linear;
    final TextDirection textDirection = Directionality.of(context);
    Tween<Offset> primaryTween = _primaryTweenSlideFromRightToLeft,
        secondaryTween = _secondaryTweenSlideFromRightToLeft;
    if (animationType == AnimationType.SlideLeftToRight) {
      primaryTween = _primaryTweenSlideFromLeftToRight;
      secondaryTween = _secondaryTweenSlideFromLeftToRight;
    }
    Widget enterAnimWidget = SlideTransition(
        position: CurvedAnimation(
          parent:
              settings?.isInitialRoute == true ? secondaryAnimation : animation,
          curve: curve,
          reverseCurve: reverseCurve,
        ).drive(
            settings?.isInitialRoute == true ? secondaryTween : primaryTween),
        textDirection: textDirection,
        child: child);
    if (isExitPageAffectedOrNot != true || settings?.isInitialRoute == true)
      return enterAnimWidget;
    return SlideTransition(
        position: CurvedAnimation(
          parent: secondaryAnimation,
          curve: curve,
          reverseCurve: reverseCurve,
        ).drive(secondaryTween),
        textDirection: textDirection,
        child: enterAnimWidget);
  }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}

/// 单一动画路由，指只有EnterPage才有的动画路由
class UnitaryAnimationPageRoute<T> extends PageRouteBuilder<T> {
  UnitaryAnimationPageRoute({
    @required this.builder,
    this.animationType = AnimationType.SlideRightToLeft,
    RouteSettings settings,
    Duration animationDuration = const Duration(milliseconds: 300),
    bool opaque = true,
    bool barrierDismissible = false,
    Color barrierColor,
    String barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false,
  })  : assert(builder != null),
        assert(opaque != null),
        assert(barrierDismissible != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        super(
            settings: settings,
            pageBuilder: (ctx, _, __) => builder(ctx),
            transitionsBuilder: (ctx, animation, _, __) {
              Widget page = builder(ctx);
              switch (animationType) {
                case AnimationType.Fade:
                  return _buildFadeTransition(animation, page);
                case AnimationType.SlideBottomToTop:
                case AnimationType.SlideTopToBottom:
                  return _buildVerticalTransition(
                      animation, animationType, page);
                case AnimationType.SlideLeftToRight:
                case AnimationType.SlideRightToLeft:
                  return _buildHorizontalTransition(
                      animation, animationType, page);
                default:
                  return page;
              }
            },
            transitionDuration: animationDuration,
            opaque: opaque,
            barrierDismissible: barrierDismissible,
            barrierColor: barrierColor,
            barrierLabel: barrierLabel,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog);

  /// 页面构建
  final WidgetBuilder builder;

  /// 动画类型
  final AnimationType animationType;

  /// 构建Fade效果的动画
  static FadeTransition _buildFadeTransition(
          Animation<double> animation, Widget child) =>
      FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.linearToEaseOut,
            reverseCurve: Curves.easeInToLinear,
          ).drive(_tweenFade),
          child: child);

  /// 构建上下向的动画
  static SlideTransition _buildVerticalTransition(
          Animation<double> animation, AnimationType type, Widget child) =>
      SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.linearToEaseOut,
            reverseCurve: Curves.easeInToLinear,
          ).drive(type == AnimationType.SlideBottomToTop
              ? _primaryTweenSlideFromBottomToTop
              : _primaryTweenSlideFromTopToBottom),
          child: child);

  /// 构建左右向的动画
  static SlideTransition _buildHorizontalTransition(
          Animation<double> animation, AnimationType type, Widget child) =>
      SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.linearToEaseOut,
            reverseCurve: Curves.easeInToLinear,
          ).drive(type == AnimationType.SlideLeftToRight
              ? _primaryTweenSlideFromLeftToRight
              : _primaryTweenSlideFromRightToLeft),
          child: child);
}
