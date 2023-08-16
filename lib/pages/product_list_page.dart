import 'dart:io';

import 'package:ecom_user_app/pages/cart_page.dart';
import 'package:ecom_user_app/providers/cart_provider.dart';
import 'package:ecom_user_app/utils/constants.dart';
import 'package:ecom_user_app/widgets/main_drawer.dart';
import 'package:ecom_user_app/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class ProductListPage extends StatefulWidget {
  static const String routeName = '/products';

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    _productProvider.getAllProducts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
        appBar: AppBar(
          title: const Text("Product List"),
          actions: [
            Consumer<CartProvider>(
              builder:(context,provider,_)=> Stack(
                children: [
                  IconButton(
                      onPressed: ()=>
                    Navigator.pushNamed(context, CartPage.routeName),

                      icon: Icon(Icons.shopping_cart)),
                  Container(
                    alignment: Alignment.center,
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Text('${provider.totalItemsInCart}'),
                  )
                ],
              ),
            )
          ],
        ),
        body: _productProvider.productList.isEmpty ? const Center(
          child: Text('No items found'),
        ) : GridView.count(
          padding: EdgeInsets.all(4),
         crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 0.5,
          children: _productProvider.productList.map((product) => ProductItem(product)).toList(),

        )
    );
  }
    Widget fabeImageWidget(String url){
      return FadeInImage.assetNetwork(
        fadeInDuration: const Duration(seconds: 2),
          fadeInCurve: Curves.bounceInOut,
          fit: BoxFit.cover,
          placeholder: 'images/img.png',
          image: url
      );
    }
  }

