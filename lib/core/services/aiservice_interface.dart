import 'dart:io';

import 'package:study_snap/core/models/solution_step.dart';

abstract class ApiServiceInterface {
  Future<SolutionResult> solveFromImage(File imageFile) async {
    throw UnimplementedError('solveFromImage is not implemented');
  }
}
