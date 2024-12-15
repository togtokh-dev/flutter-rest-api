import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/seller.dart'; // Product model

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiClient _apiClient = ApiClient();
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  // Fetch product list from API
  Future<void> _fetchProducts() async {
    try {
      final response = await _apiClient.post(
        "${ApiConstants.baseUrlSeller}${ApiConstants.productEndpoint}",
        {"chanel": "MOBILE-APP", "query": {}},
      );

      if (response.data['success']) {
        setState(() {
          _products = (response.data['data'] as List)
              .map((item) => Product.fromJson(item))
              .toList();
          _isLoading = false;
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to load products");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _fetchProducts,
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh Products",
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildProductList(),
    );
  }

  // Pull-to-refresh with RefreshIndicator
  Widget _buildProductList() {
    return RefreshIndicator(
      onRefresh: _fetchProducts, // Pull-to-refresh action
      child: _products.isEmpty
          ? const Center(child: Text("No products available"))
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return _buildProductCard(product);
              },
            ),
    );
  }

  // Widget to display each product card
  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        // Navigate to ProductDetailsScreen with the product ID
        Navigator.pushNamed(
          context,
          '/product/${product.id}', // Pass product ID as route parameter
        );
      },
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
                child: Image.network(
                  product.logo ?? '', // Use Product model field
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
            // Product Title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name ?? 'Unknown Product', // Use Product model field
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Product Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                product.description ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Product Discount
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.discount != null
                    ? "Discount: ${product.discount}%"
                    : '',
                style: const TextStyle(fontSize: 12, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
