import 'package:flutter/material.dart';

/// 绘制圆角按钮
class RoundedButton extends StatelessWidget {
  RoundedButton({
    Key key,
    double width,
    double height,
    BoxConstraints constraints,
    this.margin,
    this.padding,
    this.borderSide = BorderSide.none,
    this.alignment = Alignment.center,
    this.borderRadius = const BorderRadius.all(Radius.circular(100000)),
    this.color,
    this.isMaterialEnabled = true,
    this.onPressed,
    @required this.child,
  })  : assert(margin == null || margin.isNonNegative),
        assert(padding == null || padding.isNonNegative),
        assert(constraints == null || constraints.debugAssertIsValid()),
        constraints = (width != null || height != null)
            ? (constraints ?? BoxConstraints())
                    ?.tighten(width: width, height: height) ??
                BoxConstraints.tightFor(width: width, height: height)
            : constraints,
        super(key: key);

  final EdgeInsets margin;
  final BoxConstraints constraints;
  final EdgeInsets padding;
  final Color color;
  final BorderSide borderSide;
  final BorderRadius borderRadius;
  final Alignment alignment;
  final Widget child;
  final bool isMaterialEnabled;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    if (onPressed != null) {
      var clickableChild = Container(
          constraints: constraints,
          padding: padding,
          alignment: alignment ?? Alignment.center,
          child: child);
      return isMaterialEnabled != true
          ? GestureDetector(onTap: onPressed, child: clickableChild)
          : _buildMarginContainer(Material(
              color: color ?? Colors.transparent,
              shape: RoundedRectangleBorder(
                  side: borderSide, borderRadius: borderRadius),
              child: InkWell(
                  onTap: onPressed,
                  borderRadius: borderRadius,
                  child: clickableChild)));
    }
    return Container(
        constraints: constraints,
        decoration: ShapeDecoration(
            color: color ?? Colors.transparent,
            shape: RoundedRectangleBorder(
                side: borderSide, borderRadius: borderRadius)),
        margin: margin,
        padding: padding,
        alignment: alignment ?? Alignment.center,
        child: child);
  }

  Widget _buildMarginContainer(Widget child) =>
      Padding(padding: margin ?? EdgeInsets.zero, child: child);
}
