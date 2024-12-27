import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _controllerInitFuture;
  File? _img;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
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
        title: const Text('Capture an Image...'),
      ),
      body: FutureBuilder<void>(
          future: _controllerInitFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _controllerInitFuture;
            final image = await _controller.takePicture();
            if (!context.mounted) return;
            setState(() {
              _img = File(image.path);
            });
            final url = Uri.parse('http://192.168.0.102:8080/upload_image');
            var request = http.MultipartRequest('POST', url);
            request.files
                .add(await http.MultipartFile.fromPath('image', _img!.path));
            var response = await request.send();
            if (response.statusCode == 200)
              print('Success!');
            else
              print('Failed!');
          } catch (e) {
            print(e);
          }
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}
