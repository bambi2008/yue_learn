import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yue_learn/widgets/adaptive_content.dart';

void main() {
  testWidgets('caps wide content and fills an iPhone-sized viewport', (
    tester,
  ) async {
    final contentKey = GlobalKey();

    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveContent(
            maxWidth: 720,
            child: SizedBox(key: contentKey, height: 100),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(contentKey)).width, 720);

    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pump();

    expect(tester.getSize(find.byKey(contentKey)).width, 390);
  });
}
