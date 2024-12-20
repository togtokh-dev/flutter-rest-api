import 'package:flutter/material.dart';
import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/seller.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final ApiClient _apiClient = ApiClient();
  Order? _orderDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    try {
      final response = await _apiClient.get(
        "${ApiConstants.baseUrlSeller}/seller/main/v1/order/${widget.orderId}",
      );

      if (response.data['success']) {
        setState(() {
          _orderDetails = Order.fromJson(response.data['data']);
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to load order details.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orderDetails != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order ID: ${_orderDetails!.orderId}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text("Amount: ${_orderDetails!.amount ?? 'N/A'}"),
                      Text("Status: ${_orderDetails!.status ?? 'N/A'}"),
                      Text("Paid Type: ${_orderDetails!.paidType ?? 'N/A'}"),
                      Text(
                          "Created Date: ${_orderDetails!.createdDate ?? 'N/A'}"),
                    ],
                  ),
                )
              : const Center(child: Text("No details found.")),
    );
  }
}
