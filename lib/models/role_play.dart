/// A short, branching survival conversation for offline practice.
class RolePlayTurn {
  final String prompt;
  final String exampleAnswer;
  final List<String> acceptedPatterns;
  final String successReply;
  final String nextPrompt;
  final String retryHint;

  const RolePlayTurn({
    required this.prompt,
    required this.exampleAnswer,
    required this.acceptedPatterns,
    required this.successReply,
    required this.nextPrompt,
    required this.retryHint,
  });
}

class RolePlayScenario {
  final String id;
  final String title;
  final String icon;
  final String description;
  final String opening;
  final List<RolePlayTurn> turns;

  const RolePlayScenario({
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
    required this.opening,
    required this.turns,
  });
}
