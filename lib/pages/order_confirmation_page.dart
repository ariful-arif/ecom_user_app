import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user_app/auth/firebase_auth_service.dart';
import 'package:ecom_user_app/models/order_model.dart';
import 'package:ecom_user_app/pages/order_successful_page.dart';
import 'package:ecom_user_app/pages/product_list_page.dart';
import 'package:ecom_user_app/providers/cart_provider.dart';
import 'package:ecom_user_app/providers/order_provider.dart';
import 'package:ecom_user_app/utils/constants.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderConfirmationPage extends StatefulWidget {
  static final String routeName = '/order_confirmation_page';

  @override
  _OrderConfirmationPageState createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  late OrderProvider _orderProvider;
  late CartProvider _cartProvider;
  late String _customerId;
  bool isInit = true;
  bool isLoading = true;
  String _paymentRadioGroupValue = PaymentMethod.cod;

  @override
  void didChangeDependencies() {
    _orderProvider = Provider.of<OrderProvider>(context);
    _cartProvider = Provider.of<CartProvider>(context);
    _customerId = ModalRoute.of(context)!.settings.arguments as String;
    if(isInit) {
      _orderProvider.getOrderConstants().then((_) {
        setState(() {
          isLoading = false;
        });
      });
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Order'),
      ),
      body: isLoading ?
      Center(child: CircularProgressIndicator(),) :
      SingleChildScrollView(
        child: Column(
          children: [
            buildInvoice(),
            ListTile(
              leading: Radio<String>(
                value: PaymentMethod.cod,
                groupValue: _paymentRadioGroupValue,
                onChanged: (value) {
                  setState(() {
                    _paymentRadioGroupValue = value!;
                  });
                },
              ),
              title: Text(PaymentMethod.cod),
            ),
            ListTile(
              leading: Radio<String>(
                value: PaymentMethod.online,
                groupValue: _paymentRadioGroupValue,
                onChanged: (value) {
                  setState(() {
                    _paymentRadioGroupValue = value!;
                  });
                },
              ),
              title: Text(PaymentMethod.online),
            ),
            ElevatedButton(onPressed: () {
              _placeOrder();
            }, child: Text('PLACE ORDER'))
          ],
        ),
      ),
    );
  }

  Widget buildInvoice() {
    return Card(
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: _cartProvider.cartList
                  .map((model) => ListTile(
                        title: Text(model.productName),
                        subtitle: Text('${model.price} x ${model.qty}'),
                        trailing: Text(
                            '$takaSymbol${_cartProvider.getPriceWithQty(model)}'),
                      ))
                  .toList(),
            ),
            Divider(
              height: 2,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '$takaSymbol${_cartProvider.cartItemsTotalPrice}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'After Discount (${_orderProvider.orderConstantsModel.discount}%):',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '$takaSymbol${_orderProvider.getPriceAfterDiscount(_cartProvider.cartItemsTotalPrice)}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'VAT (${_orderProvider.orderConstantsModel.vat}%):',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '$takaSymbol${_orderProvider.getTotalVatAmount(_cartProvider.cartItemsTotalPrice)}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Charge:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '$takaSymbol${_orderProvider.orderConstantsModel.deliveryCharge}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            Divider(
              height: 2,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Grand Total:',
                    style: TextStyle(fontSize: 22),
                  ),
                  Text(
                    '$takaSymbol${_orderProvider.getGrandTotal(_cartProvider.cartItemsTotalPrice)}',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _placeOrder() {
    final orderModel = OrderModel(
      customerId: _customerId,
      userId: FirebaseAuthService.currentUser!.uid,
      paymentMethod: _paymentRadioGroupValue,
      orderStatus: OrderStatus.pending,
      vat: _orderProvider.orderConstantsModel.vat,
      discount: _orderProvider.orderConstantsModel.discount,
      deliveryCharge: _orderProvider.orderConstantsModel.deliveryCharge,
      grandTotal: _orderProvider.getGrandTotal(_cartProvider.cartItemsTotalPrice),
      timestamp: Timestamp.fromDate(DateTime.now()),
    );
    _orderProvider.addNewOrder(orderModel, _cartProvider.cartList)
    .then((value) {
      _cartProvider.clearCart();
      Navigator.pushNamedAndRemoveUntil(context, OrderSuccessfulPage.routeName, ModalRoute.withName(ProductListPage.routeName));
    }).catchError((error) {

    });
  }
}
