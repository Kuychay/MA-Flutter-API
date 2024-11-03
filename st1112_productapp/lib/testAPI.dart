import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const test());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Product List'),
        ),
        body: const Center(child: Text('Loading...')),
      ),
    );
  }
}

// Function to fetch products
Future<List> _getProducts() async {
  var url = Uri.parse("http://172.20.10.2:5007/products");
  var response = await http.get(url);

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final data = json.decode(response.body)['products_list'];
    print('Data loaded successfully');
    return data;
  } else {
    throw Exception('Failed to load products');
  }
}

// Call the function when the app starts
Future<void> initApp() async {
  try {
    final products = await _getProducts();
    print('Products: $products'); // Print the list of products
  } catch (e) {
    print('Error: $e');
  }
}

// Call initApp once the app is initialized
class test extends StatelessWidget {
  const test({super.key});

  @override
  Widget build(BuildContext context) {
    initApp(); // Call the function here to see results in terminal

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Product List'),
        ),
        body: const Center(child: Text('Loading...')),
      ),
    );
  }
}
