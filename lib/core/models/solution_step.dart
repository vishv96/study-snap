class SolutionStep {
  final int step;
  final String title;
  final String explanation;
  final String summary;

  SolutionStep({
    required this.step,
    required this.title,
    required this.explanation,
    required this.summary,
  });

  factory SolutionStep.fromJson(Map<String, dynamic> json) => SolutionStep(
    step: json['step'],
    title: json['title'],
    explanation: json['explanation'],
    summary: json['summary'],
  );
}

class SolutionResult {
  final String type;
  final String answer;
  final List<SolutionStep> steps;
  final String concept;

  SolutionResult({
    required this.type,
    required this.answer,
    required this.steps,
    required this.concept,
  });

  factory SolutionResult.fromJson(Map<String, dynamic> json) {
    return SolutionResult(
      type: json['type'],
      answer: json['answer'],
      steps: (json['steps'] as List)
          .map((e) => SolutionStep.fromJson(e))
          .toList(),
      concept: json['concept'],
    );
  }
}