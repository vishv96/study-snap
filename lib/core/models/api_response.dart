import 'package:study_snap/core/models/solution_step.dart';

class ApiResponse {
  final bool isError;
  final String? errorCode;
  final String? errorMessage;
  final SolutionResult? solutionResult;
  ApiResponse({
    required this.isError,
    this.errorCode,
    this.errorMessage,
    this.solutionResult,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    if (json['error'] == true) {
      return ApiResponse(
        isError: true,
        errorCode: json['error_code'],
        errorMessage: json['error_message'],
      );
    } else {
      return ApiResponse(
        isError: false,
        solutionResult: SolutionResult.fromJson(json['result']),
      );
    }
  }
}
