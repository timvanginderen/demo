import 'package:demo/core/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';

extension ThemeBuildContextExt on BuildContext {
  AppColors get colors => AppColors();
}
