import 'package:flutter/material.dart';
import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/seller.dart'; // Product and Item models
import '../widgets/dynamic_input_form.dart'; // Dynamic Input Form widget

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ApiClient _apiClient = ApiClient();
  Product? _productDetails;
  List<Item> _items = [];
  bool _isLoadingDetails = true;
  bool _isLoadingItems = true;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
    _fetchProductItems();
  }

  Future<void> _fetchProductDetails() async {
    try {
      final response = await _apiClient.get(
        "${ApiConstants.baseUrlSeller}${ApiConstants.productEndpoint}${widget.productId}",
      );

      if (response.data['success']) {
        setState(() {
          _productDetails = Product.fromJson(response.data['data']);
          _isLoadingDetails = false;
        });
      } else {
        _showError("Failed to load product details.");
      }
    } catch (e) {
      _showError("Error fetching product details: $e");
    }
  }

  Future<void> _fetchProductItems() async {
    try {
      final response = await _apiClient.get(
        "${ApiConstants.baseUrlSeller}/seller/main/v1/item/?product_id=${widget.productId}&show=true",
      );

      if (response.data['success']) {
        setState(() {
          _items = (response.data['data'] as List)
              .map((item) => Item.fromJson(item))
              .toList();
          _isLoadingItems = false;
        });
      } else {
        _showError("Failed to load product items.");
      }
    } catch (e) {
      _showError("Error fetching product items: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: _isLoadingDetails
          ? const Center(child: CircularProgressIndicator())
          : _productDetails != null
              ? _buildProductContent()
              : const Center(child: Text('No product details available')),
    );
  }

  Widget _buildProductContent() {
    return RefreshIndicator(
      onRefresh: () async {
        await _fetchProductDetails();
        await _fetchProductItems();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductDetails(),
            const Divider(),
            _isLoadingItems
                ? const Center(child: CircularProgressIndicator())
                : _items.isNotEmpty
                    ? _buildItemsList()
                    : const Text("No items available for this product."),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            _productDetails!.logo ?? '',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.broken_image, size: 100)),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _productDetails!.name ?? "Unknown Product",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _productDetails!.description ?? "No description available.",
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildItemsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.image ?? '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
              ),
            ),
            title: Text(item.name ?? "Unnamed Item"),
            subtitle: Text(
                "Amount: ${item.amount ?? 'N/A'} | Discount: ${item.discount ?? 0}%"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showDynamicInputForm(item);
            },
          ),
        );
      },
    );
  }

  void _showDynamicInputForm(Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DynamicInputForm(
          itemId: item.id ?? '',
          chargeTemplate: item.chargeTemplate ?? [],
          inputCheckApi: _productDetails?.inputCheckApi ?? "",
        ),
      ),
    );
  }
}
