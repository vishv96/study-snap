import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'StudySnapp',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.4)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text("8 left today", style: TextStyle(color: Colors.grey)),
            ),
          )
        ],
      ),
      body: Column(
        spacing: 32,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon(context),
          Text(
            "Snap your homework",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            "Get step-by-step solotions \n powered by AI",
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 32,
            children: [
              cameraButton(context, () {
                Navigator.pushNamed(context, '/camera');
              }),
              galleryButton(context, () {
                Navigator.pushNamed(context, '/gallery');
              }),
            ],
          ),
        ],
      ),
    );
  }

  Container icon(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Icon(
            Icons.camera_alt_outlined,
            size: 50,
            color: Theme.of(context).colorScheme.primary,
            weight: 0.1,
          ),
        ),
      ),
    );
  }

  OutlinedButton cameraButton(BuildContext context, VoidCallback onClick) {
    return OutlinedButton(
      onPressed: onClick,
      style: OutlinedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      child: Column(
        children: [
          Icon(Icons.camera_alt_outlined, color: Colors.white),
          Text(
            "Camera",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  OutlinedButton galleryButton(BuildContext context, VoidCallback onClick) {
    return OutlinedButton(
      onPressed: onClick,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      child: Column(
        children: [
          Icon(Icons.photo_library_outlined, color: Colors.white),
          Text(
            "Gallery",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
