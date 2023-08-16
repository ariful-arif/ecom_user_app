import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user_app/models/customer_model.dart';
import 'package:ecom_user_app/models/product_model.dart';

class FirestoreHelper {
  static const String _collectionProduct = 'Products';
  static const String _collectionCategory = 'Categories';
  static const String _collectionCustomer = 'Customers';

  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCategories() =>
      _db.collection(_collectionCategory).orderBy('name').snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProduct() => _db
      .collection(_collectionProduct)
      .where('isAvailable', isEqualTo: true)
      .snapshots();

  static Future<QuerySnapshot<Map<String, dynamic>>> findCustomerByPhone(
      String phone) {
    return _db
        .collection(_collectionCustomer)
        .where('customerPhone', isEqualTo: phone)
        .get();
  }

  static Future<String>addNewCustomer(CustomerModel customerModel) async{
    final docRef = _db
        .collection(_collectionCustomer).doc();
    customerModel.customerId = docRef.id;
    await docRef.set(customerModel.toMap());
    return docRef.id;
  }
  static Future<void>updateCustomer(CustomerModel customerModel){
    final docRef = _db
        .collection(_collectionCustomer).doc(customerModel.customerId);

    return docRef.update(customerModel.toMap());
  }

}

