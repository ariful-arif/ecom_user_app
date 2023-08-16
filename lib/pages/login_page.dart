import 'package:ecom_user_app/auth/firebase_auth_service.dart';
import 'package:ecom_user_app/pages/product_list_page.dart';
import 'package:ecom_user_app/providers/product_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  String errMsg = '';
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            children: [
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(25.0),
                child: Text('User Login'),
              )),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value;
                },
                decoration: const InputDecoration(
                    labelText: 'Email Address', border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value;
                },
                decoration: const InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: (){
                      isLogin = true;
                      _loginUser();
                    },
                    child: const Text('Login')),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("New User?"),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.cyanAccent
                    ),
                    onPressed: (){
                      isLogin = false;
                      _loginUser();
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                  child: Text(
                errMsg,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _loginUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        User? user;
        if(isLogin){
          user = await FirebaseAuthService.loginUser(_email!, _password!);
        }else{
          user = await FirebaseAuthService.loginUser(_email!, _password!);
        }
        // final user = await FirebaseAuthService.loginUser(_email!, _password!);
        if (user != null) {
          Navigator.pushReplacementNamed(context, ProductListPage.routeName);

        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errMsg = e.message!;
        });
      }
    }
  }
}
