import 'package:flutter/material.dart';

/// Keeps reading and interaction surfaces comfortable on iPad-sized screens.
///
/// The child still fills the available width on iPhone, but is centered and
/// capped on wider layouts so cards, dialogue bubbles, and forms do not
/// stretch across the entire iPad canvas.
class AdaptiveContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const AdaptiveContent({super.key, required this.child, this.maxWidth = 720});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : maxWidth;
        final width = availableWidth < maxWidth ? availableWidth : maxWidth;

        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(width: width, child: child),
        );
      },
    );
  }
}
