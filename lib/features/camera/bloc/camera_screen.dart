import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_snap/features/camera/bloc/camera_bloc.dart';
import 'package:study_snap/features/camera/bloc/camera_state.dart';
import 'package:study_snap/features/camera/result_screen.dart';

import 'cmera_event.dart';

final class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  Widget build(BuildContext context) {
    return BlocConsumer<CameraBloc, CameraState>(
      listener:
          (context, state) => {
            if (state.result != null)
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ResultScreen(result:state.result!)),
                ),
              },
          },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Camera')),
          body: BlocBuilder<CameraBloc, CameraState>(
            buildWhen: (prev, curr) {
              return curr.status != CameraStatus.loading;
            },
            builder: (context, state) {
              switch (state.status) {
                case CameraStatus.initial:
                  return buildInitialState(context);
                case CameraStatus.loaded:
                  return buildLoadedState(context, state);
                case CameraStatus.error:
                  // TODO: Handle this case.
                  throw UnimplementedError();
                default:
                  return SizedBox.shrink();
              }
            },
          ),
        );
      },
    );
  }

  Widget buildInitialState(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                context.read<CameraBloc>().add(OpenCamera());
              },
              child: Center(child: Text('Open Camera')),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                context.read<CameraBloc>().add(OpenGallery());
              },
              child: Center(child: Text('Open Gallery')),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoadingState(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget buildLoadedState(BuildContext context, CameraState state) {
    return Column(
      spacing: 20,
      children: [
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: BlocBuilder<CameraBloc, CameraState>(
            buildWhen: (prev, curr) {
              return prev.image != curr.image;
            },
            builder: (context, state) {
              return SizedBox(height: 500, child: Image.file(state.image!));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32),
          child: buildSolveButton(context, state),
        ),
        BlocBuilder<CameraBloc, CameraState>(
          buildWhen: (prev, curr) {
            return prev.status != curr.status;
          },
          builder: (context, state) {
            if (state.status == CameraStatus.loading) {
              return const CircularProgressIndicator();
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Widget buildSolveButton(BuildContext context, CameraState state) {
    return OutlinedButton(
      onPressed: () {
        context.read<CameraBloc>().add(SolveEvent(state.image!));
      },
      child: Center(child: Text('Solve')),
    );
  }
}
