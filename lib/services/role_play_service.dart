import '../models/role_play.dart';

class RolePlayResult {
  final String reply;
  final bool accepted;
  final bool completed;
  final int nextTurn;

  const RolePlayResult({
    required this.reply,
    required this.accepted,
    required this.completed,
    required this.nextTurn,
  });
}

class RolePlayService {
  RolePlayResult respond({
    required RolePlayScenario scenario,
    required int turnIndex,
    required String input,
  }) {
    final safeIndex = turnIndex.clamp(0, scenario.turns.length - 1);
    final turn = scenario.turns[safeIndex];
    final normalized = input.toLowerCase().replaceAll(' ', '');
    final accepted = turn.acceptedPatterns.any(
      (pattern) =>
          normalized.contains(pattern.toLowerCase().replaceAll(' ', '')),
    );

    if (!accepted) {
      return RolePlayResult(
        reply: '明白你想表达咩，不过可以再讲一次吗？\n${turn.retryHint}',
        accepted: false,
        completed: false,
        nextTurn: safeIndex,
      );
    }

    final next = safeIndex + 1;
    final completed = next >= scenario.turns.length;
    return RolePlayResult(
      reply: completed
          ? '${turn.successReply}\n${turn.nextPrompt}'
          : '${turn.successReply}\n${turn.nextPrompt}',
      accepted: true,
      completed: completed,
      nextTurn: completed ? safeIndex : next,
    );
  }
}
