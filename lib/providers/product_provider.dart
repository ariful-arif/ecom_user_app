import 'package:ecom_user_app/db/firestore_helper.dart';
import 'package:ecom_user_app/models/product_model.dart';
import 'package:flutter/foundation.dart';

class ProductProvider extends ChangeNotifier {
  List<String> categoryList = [];
  List<ProductModel> productList = [];

  void getAllProducts(){
    FirestoreHelper.getAllProduct().listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  void getAllCategories(){
    FirestoreHelper.getCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length, (index) => snapshot.docs[index].data()['name']);
      notifyListeners();
    });
  }

}
