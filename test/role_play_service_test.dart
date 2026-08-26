import 'package:flutter_test/flutter_test.dart';

import 'package:yue_learn/data/role_play_scenarios.dart';
import 'package:yue_learn/services/role_play_service.dart';

void main() {
  test('offline role play accepts a useful phrase and advances', () {
    final service = RolePlayService();
    final scenario = rolePlayScenarios.first;

    final result = service.respond(
      scenario: scenario,
      turnIndex: 0,
      input: '唔該，我要一個A餐。',
    );

    expect(result.accepted, isTrue);
    expect(result.nextTurn, 1);
    expect(result.reply, contains('热奶茶'));
  });

  test('offline role play gives a retry hint for an unrelated answer', () {
    final service = RolePlayService();
    final scenario = rolePlayScenarios.first;

    final result = service.respond(
      scenario: scenario,
      turnIndex: 0,
      input: '我想去旺角。',
    );

    expect(result.accepted, isFalse);
    expect(result.nextTurn, 0);
    expect(result.reply, contains('熱奶茶'));
  });
}
