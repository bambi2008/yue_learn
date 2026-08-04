import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../theme/app_colors.dart';

class AudioButton extends StatelessWidget {
  final String audioPath;
  final double size;
  final Color? color;

  const AudioButton({
    super.key,
    required this.audioPath,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audio, _) {
        final isCurrentPlaying =
            audio.currentAudio == audioPath && audio.isPlaying;

        return GestureDetector(
          onTap: () => audio.play(audioPath),
          onLongPress: () {
            audio.toggleSpeed();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('语速: ${audio.speed}x'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: (color ?? AppColors.primary).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCurrentPlaying ? Icons.pause : Icons.volume_up_rounded,
              color: color ?? AppColors.primary,
              size: size * 0.55,
            ),
          ),
        );
      },
    );
  }
}
