
import 'dart:io';

import 'package:study_snap/core/models/solution_step.dart';
import 'package:study_snap/core/services/aiservice_interface.dart';

final class AiMockService extends ApiServiceInterface {
  @override
  Future<SolutionResult> solveFromImage(File imageFile) async {
    await Future.delayed(const Duration(seconds: 2));

    // Cycle through different mocks for testing variety
    final mocks = [_algebra, _geometry, _physics, _chemistry];
    final index = DateTime.now().second % mocks.length;
    return mocks[index];
  }

  static final _algebra = SolutionResult(
    type: 'System of Equations · Math',
    answer: 'x = 4, y = 1',
    concept:
        'Substitution method: solve one equation for a variable, then substitute into the other to find both values.',
    steps: [
      SolutionStep(
        step: 1,
        title: 'Set up the equations',
        explanation:
            'Write both equations clearly: 2x + 3y = 11 and x − y = 3. These are the two equations we need to solve simultaneously.',
        summary: 'We have two linear equations with two unknowns.',
      ),
      SolutionStep(
        step: 2,
        title: 'Isolate x from equation 2',
        explanation:
            'From x − y = 3, add y to both sides: x = y + 3. This expresses x in terms of y so we can substitute it.',
        summary: 'Now x is expressed as y + 3.',
      ),
      SolutionStep(
        step: 3,
        title: 'Substitute into equation 1',
        explanation:
            'Replace x in 2x + 3y = 11 with (y + 3): 2(y + 3) + 3y = 11. Expand: 2y + 6 + 3y = 11. Combine: 5y + 6 = 11.',
        summary: 'We now have a single equation with one unknown.',
      ),
      SolutionStep(
        step: 4,
        title: 'Solve for y, then x',
        explanation:
            '5y = 5, so y = 1. Substitute back: x = 1 + 3 = 4. The solution is x = 4, y = 1. ✓',
        summary: 'Both values found: x = 4 and y = 1.',
      ),
    ],
  );

  static final _geometry = SolutionResult(
    type: 'Circle Area · Geometry',
    answer: 'Area = 78.54 cm²',
    concept:
        'Area of a circle: A = πr². Always convert diameter to radius first by dividing by 2.',
    steps: [
      SolutionStep(
        step: 1,
        title: 'Identify the given information',
        explanation:
            'The diameter of the circle is 10 cm. We need to find the area.',
        summary: 'Given: diameter = 10 cm.',
      ),
      SolutionStep(
        step: 2,
        title: 'Find the radius',
        explanation:
            'The radius is half the diameter: r = 10 ÷ 2 = 5 cm.',
        summary: 'Radius = 5 cm.',
      ),
      SolutionStep(
        step: 3,
        title: 'Apply the area formula',
        explanation:
            'The area of a circle is A = πr². Substitute r = 5: A = π × 5² = π × 25.',
        summary: 'A = 25π.',
      ),
      SolutionStep(
        step: 4,
        title: 'Calculate the result',
        explanation:
            'A = 25π ≈ 25 × 3.1416 = 78.54 cm². Round to two decimal places.',
        summary: 'Final area is 78.54 cm².',
      ),
    ],
  );

  static final _physics = SolutionResult(
    type: 'Kinematics · Physics',
    answer: 'v = 30 m/s',
    concept:
        'First equation of motion: v = u + at. Use when you know initial velocity, acceleration, and time.',
    steps: [
      SolutionStep(
        step: 1,
        title: 'List the known values',
        explanation:
            'Initial velocity u = 10 m/s, acceleration a = 4 m/s², time t = 5 s. We need to find final velocity v.',
        summary: 'u = 10, a = 4, t = 5.',
      ),
      SolutionStep(
        step: 2,
        title: 'Choose the right equation',
        explanation:
            'Use the first equation of motion: v = u + at. This works because we have u, a, and t.',
        summary: 'Using v = u + at.',
      ),
      SolutionStep(
        step: 3,
        title: 'Substitute and solve',
        explanation:
            'v = 10 + (4 × 5) = 10 + 20 = 30 m/s.',
        summary: 'Final velocity is 30 m/s.',
      ),
    ],
  );

  static final _chemistry = SolutionResult(
    type: 'Molar Mass · Chemistry',
    answer: '36.03 g',
    concept:
        'Molar mass is the sum of all atomic masses in a formula. Multiply by the number of each atom present.',
    steps: [
      SolutionStep(
        step: 1,
        title: 'Write the chemical formula',
        explanation:
            'Water is H₂O — two hydrogen atoms and one oxygen atom.',
        summary: 'Formula: H₂O.',
      ),
      SolutionStep(
        step: 2,
        title: 'Find atomic masses',
        explanation:
            'From the periodic table: Hydrogen (H) = 1.008 g/mol, Oxygen (O) = 16.00 g/mol.',
        summary: 'H = 1.008, O = 16.00.',
      ),
      SolutionStep(
        step: 3,
        title: 'Calculate molar mass',
        explanation:
            'Molar mass = (2 × 1.008) + (1 × 16.00) = 2.016 + 16.00 = 18.016 g/mol.',
        summary: 'Molar mass of water = 18.016 g/mol.',
      ),
      SolutionStep(
        step: 4,
        title: 'Find mass of 2 moles',
        explanation:
            'Mass = moles × molar mass = 2 × 18.016 = 36.03 g.',
        summary: 'Two moles of water = 36.03 g.',
      ),
    ],
  );
}