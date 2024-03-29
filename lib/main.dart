import 'dart:convert';

import 'package:api/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:api/model.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  Future getProducts() async {
    List listProducts = [];
    var response = await http.get(Uri.http('fakestoreapi.com', 'products'));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      for (var data in jsonData) {
        final _products = products(
            id: data['id'],
            title: data['title'],
            price: data['price'],
            description: data['description'],
            category: data['category'],
            image: data['image']);
        listProducts.add(_products);
      }
    } else {
      throw Exception('Failed to load data');
    }
    print(listProducts.length);
    return listProducts;
  }

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getProducts();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[100],
      ),
      body: FutureBuilder(
          future: getProducts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(itemBuilder: (context, index) {
                products _products = snapshot.data[index];
                return ListTile(
                  title: Image(image: NetworkImage(_products.image)),
                  subtitle: Text(_products.title),
                );
              });
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
