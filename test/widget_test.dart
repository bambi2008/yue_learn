import 'package:flutter_test/flutter_test.dart';

import 'package:yue_learn/models/review_card.dart';
import 'package:yue_learn/models/user_progress.dart';

void main() {
  test('review card advances its interval after a good answer', () {
    final card = ReviewCard(
      id: 'card-1',
      vocabId: 'vocab-1',
      cantonese: '唔該',
      jyutping: 'm4 goi1',
      mandarin: '谢谢',
      audioPath: '',
    );

    card.update(2);

    expect(card.repetitions, 1);
    expect(card.interval, 1);
    expect(card.easiness, greaterThan(2.5));
  });

  test('first study day starts a streak', () {
    final progress = UserProgress();

    progress.markStudied();

    expect(progress.streakDays, 1);
  });
}
