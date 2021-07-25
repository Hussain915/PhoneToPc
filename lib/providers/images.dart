import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class Images with ChangeNotifier {
  final List<File> _images = [];

  List<File> get images{
    return _images;
  }

  Future<void> addImages(List<File> images, String name) async{
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    for (var i = 0; i < images.length; i++) {
      _images.add(images[i]);
      final fileName = path.basename(images[i].path);
      final savedImage = await images[i].copy('${appDir.path}/$name/$fileName');
    }
  }

  void loadImages(String name){
    // ...
  }
}