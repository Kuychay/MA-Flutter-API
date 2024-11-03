import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDetail extends StatelessWidget {
  final String id;

  const ProductDetail({super.key, required this.id});

  Future<Map<String, dynamic>> _fetchProductDetail() async {

    var url = Uri.parse("http://10.0.2.2:5007/products/$id");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['products_list'] is List && data['products_list'].isNotEmpty) {
        return data['products_list'][0] as Map<String, dynamic>;
      } else {
        throw Exception("Product not found in products_list.");
      }
    } else {
      throw Exception('Failed to load product details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
        backgroundColor: const Color(0xff008eff),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchProductDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var product = snapshot.data!;
            return Column(
              children: [
                // Main product details section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(product['image'], // Set fixed width
                            fit: BoxFit.cover), // Product image
                        const SizedBox(height: 10),
                        Text(
                          product['product_name'],
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${product['price'].toString()} \$",
                          style: const TextStyle(fontSize: 20, color: Colors.red),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product['description'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom section with total price and "Add to Cart" button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Total Amount", style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            "${product['price'].toString()} \$", // Display total amount here
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle add to cart action here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text("ADD TO CART", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text("No product details available."));
        },
      ),
    );
  }
}
