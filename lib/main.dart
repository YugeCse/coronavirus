import 'package:coronavirus/core/routes/animation_page_route.dart';
import 'package:coronavirus/ui/browser_page.dart';
import 'package:coronavirus/ui/home_page.dart';
import 'package:coronavirus/data/constants/route_name_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

void main() {
  runApp(MyApp());
  _initSettings();
}

void _initSettings() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}

class MyApp extends StatelessWidget {
  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
    switch (settings.name) {
      case RouteNameConstants.web:
        return AnimationPageRoute(
            builder: (_) => BrowserPage(url: arguments['url']));
      case RouteNameConstants.index:
      default:
        return UnitaryAnimationPageRoute(
            builder: (_) => HomePage(),
            animationType: AnimationType.SlideRightToLeft);
    }
  }

  @override
  Widget build(BuildContext context) => OKToast(
      dismissOtherOnShow: true,
      position: ToastPosition(align: Alignment.bottomCenter, offset: -80),
      child: MaterialApp(
          title: '全国疫情状况',
          theme: ThemeData(primarySwatch: Colors.blue),
          initialRoute: '/',
          onGenerateRoute: _onGenerateRoute));
}
