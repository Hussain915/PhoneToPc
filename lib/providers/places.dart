import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String title, File image) {
    final newPlace =
        Place(id: DateTime.now().toString(), title: title, image: image);
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert("user_places", {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
    });
  }

  Future<void> fetchAndSetPlaces(String title) async {
    final dataList = await DBHelper.getData('user_places');
    print(dataList);
    _items = dataList.where((element) => element['title'] == title)
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
          ),
        )
        .toList();

    notifyListeners();
  }
}
