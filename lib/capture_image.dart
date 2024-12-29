import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'show_image.dart';

class CaptureImageScreen extends StatefulWidget {
  const CaptureImageScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<CaptureImageScreen> createState() => _CaptureImageScreenState();
}

class _CaptureImageScreenState extends State<CaptureImageScreen> {
  late CameraController _controller;
  late Future<void> _controllerInitFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _controllerInitFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture An Image'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                'Capture an image of plant leaves. We will send the image to the server for analysis'),
            FutureBuilder(
                future: _controllerInitFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_controller);
                  } else {
                    return Column(
                      children: <Widget>[
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                        Text('Connecting to the camera...')
                      ],
                    );
                  }
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _controllerInitFuture;
            final image = await _controller.takePicture();
            if (!context.mounted) return;

            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ShowImageScreen(imagePath: image.path)));
          } catch (e) {
            final snackbar = SnackBar(
              content: Text('Error: $e'),
              action: SnackBarAction(label: 'Close', onPressed: () {}),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}
