import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_snap/core/app/study_snap_app.dart';
import 'package:study_snap/core/services/ai_service_factory.dart';
import 'package:study_snap/features/camera/bloc/camera_bloc.dart';
import 'package:study_snap/features/camera/livecam_screen.dart';
import 'package:study_snap/features/home/home_screen.dart';

import '../features/camera/bloc/camera_screen.dart';

void main() {
  runApp(const SnapApp());
}

class SnapApp extends StatelessWidget {
  const SnapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/camera': (context) => BlocProvider(
              create: (_) => CameraBloc(AiServiceFactory.create()),
              child: const LivecamScreen(),
            ),
        '/gallery': (context) => Scaffold(
              appBar: AppBar(title: const Text("Gallery")),
              body: const Center(child: Text("Gallery Screen")),
            ),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF6366F1), // indigo — your main color
          surface: Color(0xFF111114), // card backgrounds
          background: Color(0xFF0A0A0C), // screen background
          error: Colors.redAccent,
        ),
        scaffoldBackgroundColor: Color(0xFF0A0A0C),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => CameraBloc(AiServiceFactory.create()),
        child: const HomeScreen(),
      ),
    );
  }
}
