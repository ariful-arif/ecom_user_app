import 'package:ecom_user_app/models/product_model.dart';
import 'package:ecom_user_app/providers/cart_provider.dart';
import 'package:ecom_user_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  final ProductModel productModel;
  ProductItem(this.productModel);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      elevation: 7,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16)),
              child: FadeInImage.assetNetwork(
                fadeInDuration: Duration(seconds: 3),
                  fadeInCurve: Curves.bounceInOut,
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                  //height: 200,
                  placeholder: 'images/img.png',
                  image: widget.productModel.imageDownloadUrl!),
            ),
          ),
          ListTile(
            title: Text(widget.productModel.name!),
            subtitle: Text(widget.productModel.stock!.toString()),
          ),
          Text('$takaSymbol${widget.productModel.price!}',style: TextStyle(fontSize: 25),),
          Consumer<CartProvider>(
            builder:(context,provider,_)=> ElevatedButton(
              child: Text(provider.isInCart(widget.productModel.id!) ?'REMOVE':'ADD'),
              onPressed: (){
                if(provider.isInCart(widget.productModel.id!)){
                provider.removeFromCart(widget.productModel.id!);
                }else{
                provider.addToCart(widget.productModel);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
