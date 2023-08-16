import 'package:ecom_user_app/pages/cart_page.dart';
import 'package:ecom_user_app/pages/customer_info_page.dart';
import 'package:ecom_user_app/pages/launcher_page.dart';
import 'package:ecom_user_app/pages/login_page.dart';
import 'package:ecom_user_app/pages/order_confirmation_page.dart';
import 'package:ecom_user_app/pages/product_list_page.dart';
import 'package:ecom_user_app/providers/cart_provider.dart';
import 'package:ecom_user_app/providers/product_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
         ChangeNotifierProvider(create: (context) => CartProvider()),
        // ChangeNotifierProvider(create: (context) => OrderProvider()),
        // ChangeNotifierProvider(create: (context) => CustomerProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.red,
        ),
        home: LauncherPage(),
        routes: {
          LauncherPage.routeName : (context) => LauncherPage(),
          LoginPage.routeName : (context) => LoginPage(),
          ProductListPage.routeName : (context) => ProductListPage(),
          CartPage.routeName : (context) => CartPage(),
          CustomerInfoPage.routeName : (context) => CustomerInfoPage(),
          OrderConfirmationPage.routeName : (context) => OrderConfirmationPage(),

        },
      ),
    );
  }
}


