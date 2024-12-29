import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ShowImageScreen extends StatefulWidget {
  const ShowImageScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<ShowImageScreen> createState() => _ShowImageScreenState();
}

class _ShowImageScreenState extends State<ShowImageScreen> {
  late String _title;
  // late String _label;
  late Image _shownImage;

  @override
  void initState() {
    super.initState();
    _title = 'Show Image';
    _shownImage = Image.file(File(widget.imagePath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        // body: Image.file(File(widget.imagePath)),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _shownImage,
              ElevatedButton(
                  onPressed: _getPrediction, child: Text('Predict & Detect'))
            ],
          ),
        ));
  }

  Future<void> _getPrediction() async {
    final postUrl = Uri.parse('http://192.168.0.102:8080/upload_image');
    var request = MultipartRequest('POST', postUrl);
    request.files.add(
        await MultipartFile.fromPath('image', File(widget.imagePath).path));
    var response = await request.send();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Image sent to server'),
        action: SnackBarAction(label: 'Close', onPressed: () {}),
      ));
      var imagePathTokens = widget.imagePath.split('/');
      var idx = imagePathTokens.length - 1;
      final imageName = imagePathTokens[idx];
      setState(() {
        _shownImage =
            Image.network('http://192.168.0.102:8080/predict/$imageName');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to send image to server!'),
        action: SnackBarAction(label: 'Close', onPressed: () {}),
      ));
    }
  }
}
