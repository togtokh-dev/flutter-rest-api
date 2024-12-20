import 'package:flutter/material.dart';
import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/seller.dart';
import '../core/app_routes.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final ApiClient _apiClient = ApiClient();
  List<Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final response = await _apiClient.get(
        "${ApiConstants.baseUrlSeller}/seller/main/v1/order",
      );

      if (response.data['success']) {
        setState(() {
          _orders = (response.data['data'] as List)
              .map((order) => Order.fromJson(order))
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch orders.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order List")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(child: Text("No orders found."))
              : ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    return Card(
                      child: ListTile(
                        title: Text("Order ID: ${order.orderId}"),
                        subtitle: Text("Amount: \$${order.amount ?? 0.0}"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.orderDetails,
                            arguments: {"orderId": order.orderId ?? ''},
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
