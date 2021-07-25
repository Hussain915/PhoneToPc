import 'package:flutter/material.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class WalkThroughScreen extends StatefulWidget {
  final String title;
  WalkThroughScreen({this.title});
  @override
  WalkThroughScreenState createState() {
    return new WalkThroughScreenState();
  }
}

class WalkThroughScreenState extends State<WalkThroughScreen> {
  int _slideIndex = 0;

  final List<String> images = [
    "assets/images/slide_1.png",
    "assets/images/slide_2.png",
    "assets/images/slide_3.png"
  ];

  final List<String> text1 = [
    "Snap the ultimate pictures",
    "Sync all Your Favourite Images & Videos",
    "Easily access Your Items on PC"
  ];
  final List<String> text0 = [
    "You will be able to create a folder, take as many pictures as you want, it will be automatically stored in that folder",
    "All your images and videos will be automatically uploaded to a drive, when the WiFi network is available",
    "You will be able to download the exact copies of the folders that you have stored on the Phone"
  ];

  final IndexController controller = IndexController();

  @override
  Widget build(BuildContext context) {
    TransformerPageView transformerPageView = TransformerPageView(
        physics: new AlwaysScrollableScrollPhysics(),
        pageSnapping: true,
        onPageChanged: (index) {
          setState(() {
            this._slideIndex = index;
          });
        },
        loop: false,
        controller: controller,
        transformer: new PageTransformerBuilder(
            builder: (Widget child, TransformInfo info) {
          return new Material(
            color: Colors.white,
            elevation: 8.0,
            textStyle: new TextStyle(color: Colors.white),
            borderRadius: new BorderRadius.circular(12.0),
            child: new Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 45.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new ParallaxContainer(
                          child: CircleAvatar(
                            radius: 150.0,
                            backgroundColor: Colors.lightBlueAccent,
                            child: new Image.asset(
                              images[info.index],
                              fit: BoxFit.contain,
                              height: 350,
                            ),
                          ),
                          position: info.position,
                          translationFactor: 400.0,
                        ),
                        SizedBox(
                          height: 45.0,
                        ),
                        new ParallaxContainer(
                          child: new Text(
                            text1[info.index],
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              color: Colors.black,
                              fontSize: 27.0,
                              fontFamily: 'Segoe UI',
                              //fontWeight: FontWeight.bold
                            ),
                          ),
                          position: info.position,
                          translationFactor: 300.0,
                        ),
                        SizedBox(
                          height: 55.0,
                        ),
                        new ParallaxContainer(
                          child: new Text(
                            text0[info.index],
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontFamily: 'Segoe UI',
                              // fontWeight: FontWeight.bold
                            ),
                          ),
                          position: info.position,
                          opacityFactor: .8,
                          translationFactor: 400.0,
                        ),
                        SizedBox(
                          height: 45.0,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            print('Skip');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthScreen()),
                            );
                          },
                          child: _slideIndex < 2
                              ? Text(
                                  'Skip',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 27.0,
                                    fontFamily: 'Segoe UI',
                                  ),
                                )
                              : Text(
                                  'Done',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 27.0,
                                    fontFamily: 'Segoe UI',
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        itemCount: 3);

    return Scaffold(
      backgroundColor: Colors.white,
      body: transformerPageView,
    );
  }
}
