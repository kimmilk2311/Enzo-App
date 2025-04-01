import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
    static const String id = '\products-screen';

  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text("Products"),
      ),
    );
  }
}