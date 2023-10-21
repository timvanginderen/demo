import 'package:demo/core/data/config/app_config.dart';
import 'package:demo/core/di/di.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FlavorBanner extends StatelessWidget {
  const FlavorBanner(
      {super.key, required this.bannerColor, required this.child});

  final Color bannerColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[child, _buildBanner(context)],
    );
  }

  Widget _buildBanner(BuildContext context) {
    final AppConfig appConfig = locator();
    return Container(
      color: Colors.transparent,
      height: 60,
      width: 60,
      child: CustomPaint(
        painter: BannerPainter(
            message: describeEnum(appConfig.flavor),
            textDirection: Directionality.of(context),
            layoutDirection: Directionality.of(context),
            location: BannerLocation.bottomStart,
            color: bannerColor),
      ),
    );
  }
}
