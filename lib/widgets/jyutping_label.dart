import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 显示粤语文字 + 粤拼标注
class JyutpingLabel extends StatelessWidget {
  final String cantonese;
  final String jyutping;
  final double cantoneseSize;
  final double jyutpingSize;

  const JyutpingLabel({
    super.key,
    required this.cantonese,
    required this.jyutping,
    this.cantoneseSize = 20,
    this.jyutpingSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          cantonese,
          style: TextStyle(
            fontSize: cantoneseSize,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          jyutping,
          style: TextStyle(
            fontSize: jyutpingSize,
            color: AppColors.jyutping,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
