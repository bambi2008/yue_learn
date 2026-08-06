import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yue_learn/models/course.dart';
import 'package:yue_learn/widgets/dialogue_bubble.dart';

void main() {
  testWidgets('dialogue bubble exposes the pronunciation practice action', (
    tester,
  ) async {
    var practiceTapped = false;
    final sentence = Sentence(
      id: 'sentence-1',
      cantonese: '唔該',
      jyutping: 'm4 goi1',
      mandarin: '谢谢',
      audioPath: '',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DialogueBubble(
            sentence: sentence,
            onTap: () {},
            onPractice: () => practiceTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('跟读评分'), findsOneWidget);

    await tester.tap(find.text('跟读评分'));
    expect(practiceTapped, isTrue);
  });
}
