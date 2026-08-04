import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProgressRing extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final double size;
  final double strokeWidth;
  final Color? color;
  final Widget? child;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 80,
    this.strokeWidth = 6,
    this.color,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: strokeWidth,
            color: c.withValues(alpha: 0.1),
          ),
          CircularProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            strokeWidth: strokeWidth,
            color: c,
            strokeCap: StrokeCap.round,
          ),
          ?child,
        ],
      ),
    );
  }
}
