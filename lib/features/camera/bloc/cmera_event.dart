import 'dart:io';

sealed class CameraEvent {}

class InitializeCamera extends CameraEvent {}

class OpenCamera extends CameraEvent {}

class SolveEvent extends CameraEvent {
  File image;
  SolveEvent(this.image);
}

class ResetEvent extends CameraEvent {}

class OpenGallery extends CameraEvent {}
