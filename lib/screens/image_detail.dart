import 'dart:io';

import 'package:flutter/material.dart';

class ImageDetailScreen extends StatelessWidget {

  static const routeName = '/image-detail';

  @override
  Widget build(BuildContext context) {
    File image = ModalRoute.of(context).settings.arguments as File;
    return Scaffold(
      appBar: AppBar(title: Text("Image.."),),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Image.file(image),
        ),
      ),
    );
  }
}