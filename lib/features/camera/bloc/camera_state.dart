import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:study_snap/core/models/solution_step.dart';

enum CameraStatus { initial, loading, loaded, error }

final class CameraState extends Equatable {
  final File? image;
  final CameraStatus status;
  final String? error;
  final SolutionResult? result;

  const CameraState({
    this.image,
    this.status = CameraStatus.initial,
    this.result,
    this.error,
  });

  @override
  List<Object?> get props => [image, status, error, result];

  CameraState copyWith({File? image, CameraStatus? status, SolutionResult? result, String? error}) {
    return CameraState(
      image: image ?? this.image,
      status: status ?? this.status,
      error: error ?? this.error,
      result: result ?? this.result
    );
  }
}
