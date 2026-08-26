import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../theme/app_colors.dart';

class AudioButton extends StatelessWidget {
  final String audioPath;
  final String? text;
  final double size;
  final Color? color;

  const AudioButton({
    super.key,
    required this.audioPath,
    this.text,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Some lightweight widget previews/tests do not install the global audio
    // provider. Keep the control renderable there; in the real app the
    // provider is always present and taps remain fully functional.
    final audio = Provider.of<AudioProvider?>(context);
    final key = text == null ? audioPath : '$audioPath::$text';
    final isCurrentPlaying =
        audio != null && audio.currentAudio == key && audio.isPlaying;

    return GestureDetector(
      onTap: audio == null ? null : () => audio.play(audioPath, text: text),
      onLongPress: audio == null
          ? null
          : () {
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
  }
}
