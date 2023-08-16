
import 'package:ecom_user_app/db/firestore_helper.dart';
import 'package:ecom_user_app/models/customer_model.dart';
import 'package:flutter/foundation.dart';

class CustomerProvider with ChangeNotifier {

  Future<CustomerModel?> findCustomer(String phone) async{
    final snapshot = await FirestoreHelper.findCustomerByPhone(phone);
    if(snapshot.docs.isNotEmpty) {
      final customerModel = CustomerModel.fromMap(snapshot.docs.first.data());
      return customerModel;
    }
    return null;
  }

  Future<String> addCustomer(CustomerModel customerModel) async {
    return FirestoreHelper.addNewCustomer(customerModel);
  }

  Future<void> updateCustomer(CustomerModel customerModel) {
    return FirestoreHelper.updateCustomer(customerModel);
  }

}