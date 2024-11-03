import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'ProductDetail.dart';

Future<List>? _myFuture;

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  void initState() {
    // Load data once
    _myFuture = _getProducts();
  }

  Future<List> _getProducts() async {
    var url = Uri.parse("http://10.0.2.2:5007/products");
    var response = await http.get(url);

    final data = json.decode(response.body)['products_list'];
    //print('Data loaded successfully: $data');
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff008eff),
          title: const Text('Product List'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              color: Colors.white,
              tooltip: 'Cart Icon',
              onPressed: () {},
            ),
          ],
        ),
        body: FutureBuilder<List>(
          future: _getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              var products = snapshot.data!;

              return GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items per row
                  crossAxisSpacing: 10.0, // Horizontal spacing
                  mainAxisSpacing: 10.0, // Vertical spacing
                  childAspectRatio: 0.75, // Aspect ratio of grid items
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetail(
                                      id: products[index]['id'].toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 150, // Set fixed width
                                height: 250, // Set fixed height
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[200],
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Image.network(
                                  products[index]['image'],
                                  fit: BoxFit.cover, // Scale to fit within fixed size
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),

                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              products[index]['product_name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2, // Limit lines for product name
                              overflow: TextOverflow.ellipsis, // Add ellipsis for long text
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "${products[index]['price'].toString()} \$",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    print("Favorite");
                                  },
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Handle cart addition logic here
                                  },
                                  icon: const Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text("No products available."));
          },
        ),
      ),
    );
  }
}
