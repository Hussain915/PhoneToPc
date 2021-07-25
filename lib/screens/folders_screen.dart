import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shop/colors.dart';

import '../providers/folders.dart';
import '../widgets/folder_item.dart';
import '../providers/auth.dart';

class FolderScreen extends StatefulWidget {
  @override
  _FolderScreenState createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Create a Folder'),
            content: TextField(
              // onChanged: (value) {
              //   setState(() {
              //     valueText = value;
              //   });
              // },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Folder Name"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.white,
                textColor: Colors.black,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: appBarColor,
                textColor: Colors.white,
                child: Text('Create'),
                onPressed: () {
                  Provider.of<Folders>(context, listen: false)
                      .addFolder(_textFieldController.text);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<SnackBar> _connectivity(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print("In the connectivity function");
    if (connectivityResult == ConnectivityResult.wifi) {
      // return SnackBar(content: Text("Uploading"));
      return showDialog(
          context: context,
          builder: (context) {
            return FutureBuilder(
              future: Provider.of<Folders>(context, listen: false).uploadData(),
              builder: (ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? AlertDialog(
                          title: Center(
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                Text("Uploading"),
                              ],
                            ),
                          ),
                        )
                      : AlertDialog(
                          title: Center(
                            child: Text("Uploaded"),
                          ),
                          actions: [
                            FlatButton(
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: Text('Ok'),
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                            ),
                          ],
                        ),
            );
          });

      // return SnackBar(content: Text("Uploaded"));
    } else {
      return SnackBar(content: Text("No wifi is available."));
    }
  }

  String valueText;

  @override
  Widget build(BuildContext context) {
    // final foldersP = Provider.of<Folders>(context);
    // final folders = foldersP.folders;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: Text("Folders"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.upload_file),
          onPressed: () async {
            var snackBar = await _connectivity(context);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              Provider.of<Auth>(context, listen: false)
                  .logout(context: context);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future:
            Provider.of<Folders>(context, listen: false).fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<Folders>(
                builder: (ctx, folders, ch) => folders.folders.length <= 0
                    ? ch
                    : GridView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: folders.folders.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (ctx, i) {
                          return ProductItem(folders.folders[i]);
                        }),
                child: Center(
                  child: Text("No folders added"),
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: () async {
            await _displayTextInputDialog(context);
          },
        ),
      ),
    );
  }
}
