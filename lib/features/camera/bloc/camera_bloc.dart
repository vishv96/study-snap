import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:study_snap/core/services/aiservice_interface.dart';
import 'package:study_snap/core/models/solution_step.dart';
import 'package:study_snap/core/services/ai_service.dart';
import 'package:study_snap/features/camera/bloc/camera_state.dart';
import 'package:study_snap/features/camera/bloc/cmera_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {

  ApiServiceInterface service;

  CameraBloc(this.service) : super(CameraState()) {
    on<OpenCamera>(_onOpenCamera);
    on<InitializeCamera>(_onInitializeCamera);
    on<SolveEvent>(_onSolveEvent);
    on<OpenGallery>(_onOpenGallery);
  }

  Future<void> _onOpenCamera(
    CameraEvent event,
    Emitter<CameraState> emit,
  ) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 85,
    );
    _handle(image);
  }

  Future<void> _onOpenGallery(
    CameraEvent event,
    Emitter<CameraState> emit,
  ) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 85,
    );
    _handle(image);
  }

  void _handle(XFile? image) {
    if (image == null) {
      emit(state.copyWith(status: CameraStatus.error));
      return;
    } else {
      emit(
        state.copyWith(image: File(image.path), status: CameraStatus.loaded),
      );
    }
  }

  void _onInitializeCamera(InitializeCamera event, Emitter<CameraState> emit) {
    emit(state.copyWith(status: CameraStatus.initial));
  }

  Future<void> _onSolveEvent(
    SolveEvent event,
    Emitter<CameraState> emit,
  ) async {
    emit(state.copyWith(image: event.image));
    emit(state.copyWith(status: CameraStatus.loading));
    try {
      SolutionResult response = await service.solveFromImage(state.image!);
      emit(state.copyWith(status: CameraStatus.loaded, result: response));
    } catch (e) {
      emit(state.copyWith(error: "$e", status: CameraStatus.error));
    }
  }
}
