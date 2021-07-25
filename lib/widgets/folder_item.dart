import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../providers/auth.dart';
// import '../providers/folders.dart';
import '../screens/images_screen.dart';
import '../providers/images.dart';

class ProductItem extends StatelessWidget {
  final String name;
  // final String title;
  // final String imageUrl;

  ProductItem(this.name);

  @override
  Widget build(BuildContext context) {
    // final folders = Provider.of<Folders>(context, listen: false);
    // final scaffold = ScaffoldMessenger.of(context);
    // final cart = Provider.of<Cart>(context, listen: false);
    // final authData = Provider.of<Auth>(context, listen: false);
    print("Product Rebuilds");
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ImagesScreen.routeName,
              arguments: name,
            );
          },
          child: FittedBox(child: Icon(Icons.folder, color: Colors.blue[200],), fit: BoxFit.cover,),
          // child: Hero(
          //   tag: name,
          //   child: FadeInImage(
          //     placeholder: AssetImage("assets/images/product-placeholder.png"),
          //     image: NetworkImage(product.imageUrl, ),
          //     fit: BoxFit.cover,
          //   ),
          // ),
        ),
        footer: GridTileBar(
          // leading: Consumer<Product>(
          //   builder: (ctx, product, child) => IconButton(
          //     icon: Icon(
          //         product.isFavourite ? Icons.favorite : Icons.favorite_border),
          //     onPressed: () async{
          //       try{
          //         await product.toggleFavouriteStatus(authData.token, authData.userId);  
          //       } catch (e) {
          //         scaffold.showSnackBar(
          //           SnackBar(content: Text("Marking as favourite failed")),
          //         );
          //       }
          //     },
          //     color: Theme.of(context).accentColor,
          //   ),
          // ),
          // backgroundColor: Colors.black,
          title: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            textScaleFactor: 1.0,
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.black45,),
            onPressed: () {
              // cart.addItem(product.id, product.price, product.title);

              // ScaffoldMessenger.of(context).hideCurrentSnackBar();
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text("Added Item to Cart", textAlign: TextAlign.center,),
              //   duration: Duration(seconds: 2),
              //   action: SnackBarAction(label: "UNDO", onPressed: () {
              //     cart.removeSingleItem(product.id);
              //   },),
              // ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}