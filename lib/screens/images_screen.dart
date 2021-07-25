import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

import '../providers/places.dart';
import './image_detail.dart';

class ImagesScreen extends StatefulWidget {
  static const routeName = '/images-screen';

  @override
  _ImagesScreenState createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  File _storedImage;

  Future<void> _takePicture(String title) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (imageFile == null) {
      return;
    }
    // Add permission for ios
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(_storedImage.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');

    Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(title, _storedImage);
  }

  @override
  Widget build(BuildContext context) {
    String name = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async{
              _takePicture(name);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(name),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPlaces>(
                builder: (ctx, greatPlaces, ch) => greatPlaces.items.length <= 0
                    ? ch
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        padding: const EdgeInsets.all(10.0),
                        itemBuilder: (_, index) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(ImageDetailScreen.routeName, arguments: greatPlaces.items[index].image);
                          },
                          child: Image.file(
                            greatPlaces.items[index].image,
                            fit: BoxFit.fill,
                          ),
                        ),
                        itemCount: greatPlaces.items.length,
                      ),
                child: Center(
                  child: Text("Got no pictures yer"),
                ),
              ),
      ),
    );
  }
}
