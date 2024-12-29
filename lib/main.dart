import 'package:flutter/material.dart';
import 'dart:async';
import 'capture_image.dart';
import 'package:camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final cameras = await availableCameras();
  // final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      // home: TakePictureScreen(camera: firstCamera),
      home: HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Leaf Disease Detector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  final cameras = await availableCameras();
                  final camera = cameras.first;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CaptureImageScreen(camera: camera)));
                },
                child: Text('Start Detecting')),
          ],
        ),
      ),
    );
  }
}
