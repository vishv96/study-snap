import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_snap/features/camera/bloc/camera_bloc.dart';
import 'package:study_snap/features/camera/bloc/camera_state.dart';
import 'package:study_snap/features/camera/bloc/cmera_event.dart';
import 'package:study_snap/features/camera/result_screen.dart';

class LivecamScreen extends StatefulWidget {
  const LivecamScreen({super.key});

  @override
  State<LivecamScreen> createState() => _LivecamScreenState();
}

class _LivecamScreenState extends State<LivecamScreen> {
  CameraController? _cameraController;
  XFile? _capturedImage;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras.first, ResolutionPreset.high);
    if (_cameraController != null) {
      await _cameraController!.initialize();
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController?.dispose();
  }

  Expanded cameraPreview() {
    return Expanded(
      flex: 5,
      child: SizedBox.expand(
        child:
            _capturedImage == null
                ? CameraPreview(_cameraController!)
                : Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text("Live Camera")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Live Camera")),
      body: BlocConsumer<CameraBloc, CameraState>(
        listener: (context, state) => {
          if (state.status == CameraStatus.error)
            {
              isProcessing = false,
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error ?? "An error occurred")),
              ),
            },
          if (state.result != null)
            {
              isProcessing = false,
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ResultScreen(result:state.result!)),
              ),
            },
        },
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: [
              _content(context),
              if (isProcessing) _progressIndicator(),
            ],
          );
        },
      ),
    );
  }

  Container _progressIndicator() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "Processing...",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Column _content(BuildContext context) {
    return Column(
      children: [
        cameraPreview(),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Row(
                children: [
                  Expanded(flex: 1, child: _retakeButton()),
                  SizedBox(width: 16),
                  Expanded(flex: 2, child: _solveItButton(context)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container _retakeButton() {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            _capturedImage = null;
          });
          _cameraController?.dispose();
          initializeCamera();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        child: Text("Retake"),
      ),
    );
  }

  Container _solveItButton(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            isProcessing = true;
          });
          _cameraController
              ?.takePicture()
              .then((XFile file) {
                // Handle the captured image file
                print('Picture saved to ${file.path}');
                context.read<CameraBloc>().add(SolveEvent(File(file.path)));
                setState(() {
                  _capturedImage = file;
                });
                // You can now use _capturedImage for further processing, like sending it to an AI service
              })
              .catchError((e) {
                // Handle any errors that occur during capture
                print('Error capturing picture: $e');
              });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.lightbulb, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Solve it",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
