import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:shop/screens/splash_screen.dart';

// import './screens/product_overview_screen.dart';
import './screens/folders_screen.dart';
// import './screens/product_detail_screen.dart';
// import './providers/products.dart';
// import './providers/cart.dart';
// import './screens/cart_screen.dart';
// import './providers/orders.dart';
// import './screens/orders_screen.dart';
// import './screens/user_product_screen.dart';
// import './screens/edit_product_screen.dart';
import './providers/auth.dart';
import './helpers/custom_route.dart';
import './screens/images_screen.dart';
import './screens/image_detail.dart';

import './providers/places.dart';
import './providers/folders.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => GreatPlaces(),
        ),
        ChangeNotifierProxyProvider<Auth, Folders>(
            update: (ctx, auth, previousFolders) => Folders(
                auth.token,
                auth.userId,
                previousFolders == null ? [] : previousFolders.folders)),
        // ChangeNotifierProvider(
        //   create: (ctx) => Folders(),
        // ),
      ],
      child: Consumer<Auth>(
        builder: (cTx, auth, _) {
          return MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.teal,
              accentColor: Colors.black12,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              }),
            ),
            home: auth.isAuth
                ? FolderScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : SplashScreen(),
                  ),
            // initialRoute:()=> SplashScreen(),
            routes: {
              ImagesScreen.routeName: (ctx) => ImagesScreen(),
              ImageDetailScreen.routeName: (ctx) => ImageDetailScreen(),
              // CartScreen.routeName: (ctx) => CartScreen(),
              // OrdersScreen.routeName: (ctx) => OrdersScreen(),
              // UserProductScreen.routeName: (ctx) => UserProductScreen(),
              // EditProductScreen.routeName: (ctx) => EditProductScreen(),
              // AuthScreen.routeName: (ctx) => AuthScreen(),
            },
          );
        },
      ),
    );
  }
}
