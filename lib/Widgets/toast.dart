import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp( MyImageWidget());
}
class MyImageWidget extends StatefulWidget {
  @override
  _MyImageWidgetState createState() => _MyImageWidgetState();
}

class _MyImageWidgetState extends State<MyImageWidget> {
  String imageUrl = '';

  Future<void> fetchImage() async {
    final response = await http.get(Uri.parse('http://192.168.1.6/image.php'));

    if (response.statusCode == 200) {
      setState(() {
        imageUrl = response.body;
      });
    } else {
      print('Failed to fetch image: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Widget'),
      ),
      body: Center(
        child: imageUrl.isEmpty
            ? CircularProgressIndicator()
            : Image.memory(
          base64Decode(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
