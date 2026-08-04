import 'package:flutter/material.dart';

/// 港风配色方案
class AppColors {
  AppColors._();

  // 主色调 - 港式霓虹暖色
  static const Color primary = Color(0xFFE85D5D); // 珊瑚红
  static const Color primaryLight = Color(0xFFF08080);
  static const Color primaryDark = Color(0xFFC04A4A);

  // 深色背景
  static const Color darkBg = Color(0xFF1A1A2E); // 深蓝黑
  static const Color darkSurface = Color(0xFF252540);
  static const Color darkCard = Color(0xFF2D2D50);

  // 暖白背景
  static const Color warmBg = Color(0xFFFFF8F0);
  static const Color warmSurface = Color(0xFFFFF0E5);
  static const Color warmCard = Color(0xFFFFFFFF);

  // 文字
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B6B80);
  static const Color textOnDark = Color(0xFFF5F5FA);

  // 粤拼标注
  static const Color jyutping = Color(0xFF5B8DEF);
  static const Color jyutpingLight = Color(0xFF8AAEF0);

  // 声调颜色 (6声调)
  static const List<Color> toneColors = [
    Color(0xFF4ECDC4), // 1声 55 高平
    Color(0xFFFF6B6B), // 2声 35 高升
    Color(0xFF45B7D1), // 3声 33 中平
    Color(0xFFF9CA24), // 4声 21 低降
    Color(0xFFA29BFE), // 5声 13 低升
    Color(0xFF2ED573), // 6声 22 低平
  ];

  // 功能色
  static const Color success = Color(0xFF2ED573);
  static const Color warning = Color(0xFFF9CA24);
  static const Color error = Color(0xFFFF4757);
  static const Color info = Color(0xFF5B8DEF);

  // SRS 评分按钮
  static const Color srsAgain = Color(0xFFFF4757);    // 重来
  static const Color srsHard = Color(0xFFFFA502);      // 困难
  static const Color srsGood = Color(0xFF2ED573);       // 良好
  static const Color srsEasy = Color(0xFF4ECDC4);       // 简单
}
