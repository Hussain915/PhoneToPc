import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:http/http.dart' as http;

import '../helpers/db_helper.dart';
// import '../providers/places.dart';

class Folders with ChangeNotifier {
  final String authToken;
  final String userId;
  List<String> _folders = [];

  Folders(this.authToken, this.userId, this._folders);

  List<String> get folders {
    return _folders;
  }

  void addFolder(String name) async {
    bool inserted = await DBHelper.insert(
        "folders", {'id': DateTime.now().toString(), 'name': name});
    if (inserted) {
      _folders.add(name);
    }
    notifyListeners();
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('folders');
    _folders = [];
    // print(dataList);
    dataList.forEach((element) {
      _folders.add(element['name']);
    });
    // _folders = dataList
    //     .map(
    //       (item) => item['name'],
    //     )
    //     .toList();
    // print("AFter the map");
    // print(_folders);

    notifyListeners();
  }

  Future<void> uploadFile(File _image, String folder) async {
    try {
      Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('$userId/$folder/${_image.path}');
      UploadTask uploadTask = storageReference.putFile(_image); 
      await uploadTask.whenComplete(() => null);
    } catch (e) {
      print(e.toString());
    }

    // return await storageReference.getDownloadURL();
}

  Future<void> uploadData() async {
    // print("In the upload Data");
    // final url =
    //     'https://shop-3f414-default-rtdb.firebaseio.com/Folders/$userId.json?auth=$authToken';
    // print("After storage instance");

    final dataList = await DBHelper.getData('user_places');
    // print(dataList);
    await Future.wait(_folders.map((folder) async{
      List images = [];
      // print(folder);
      dataList.where((element) => element['title'] == folder).toList().forEach((element) {images.add(File(element['image']));});
      // print(images);
      try {
        var imageUrls = await Future.wait(images.map((_image) => uploadFile(_image, folder)));
        if (imageUrls.isNotEmpty) {
          print(folder);
          await DBHelper.eraseData(folder);
        }
      } catch (e) {
        print("Error");
        print(e.toString());
      }
      
      //  var imageUrls = 
      // print(images);
      // try {
      //   final response = await http.post(Uri.parse(url),
      //     body: json.encode({
      //       'folder': folder,
      //       'images': images,
      //     }));
      // } catch (e) {
      //   print(e.toString());
      // }
    }));

    // _folders.forEach((folder) async {
    //   List imagesList = [];
    //   print("here");
    //   List<Map> list = await DBHelper.getRelatedImages("user_places", folder);
    //   print("Got all images");
    //   print(list);
    //   if (list.isNotEmpty) {
    //     list.forEach((element) {
    //       print(element['image']);
    //       imagesList.add(File(element['image']));
    //     });

    //     try {
    //       final response = await http.post(Uri.parse(url),
    //         body: json.encode({
    //           'folder': folder,
    //           'images': imagesList,
    //         }));
    //     } catch (e) {
    //       print(e.toString());
    //     }
    //   }
    // });
  }
}

