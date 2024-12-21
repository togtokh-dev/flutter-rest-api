import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
  bool _isProcessingPayment = false;

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

  Future<void> _processPayment(String paymentType) async {
    setState(() => _isProcessingPayment = true);

    final payload = {
      "order_ids": [widget.orderId],
      "type": paymentType,
    };

    try {
      final response = await _apiClient.post(
        "${ApiConstants.baseUrlSeller}/seller/main/v1/invoice/",
        payload,
      );

      if (response.data['success']) {
        _handlePaymentResponse(paymentType, response.data["data"]);
      } else {
        throw Exception(response.data['message'] ?? "Payment failed.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isProcessingPayment = false);
    }
  }

  void _handlePaymentResponse(String paymentType, Map<String, dynamic> data) {
    print("_handlePaymentResponse");
    print(paymentType);
    print(data);
    switch (paymentType) {
      case "TOKIPAY":
        _showPaymentOption("TokiPay", data['deeplink'], data['qr']);
        break;
      case "QPAY":
        _showPaymentOption("QPay", data['qPay_shortUrl'], data['qr_text']);
        break;
      case "HIPAY":
        _showPaymentOption("HiPay", data['deep'] ?? data['url'], data['qr']);
      case "MONPAY":
        _showPaymentOption("Monpay", data['deep'], data['qr']);
      case "GOLOMT":
        _launchUrl(data['url'] ?? '');
      case "SOCIAL":
        _showPaymentOption(
          "SOCIAL",
          data['deep_link'],
          data['qr'],
        );
      case "DIGIPAY":
        _launchUrl(data['deep'] ?? '');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unsupported payment type.")),
        );
    }
  }

  void _showPaymentOption(String title, String? link, String? qrText) {
    print(title);
    print(link);
    print(qrText);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (qrText != null && qrText.isNotEmpty)
                Center(
                  child: SizedBox(
                    width: 200, // Set a fixed width for the QR code
                    height: 200, // Set a fixed height for the QR code
                    child: QrImageView(
                      data: qrText,
                      version: QrVersions.auto,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              if (link != null && link.isNotEmpty)
                ElevatedButton(
                  onPressed: () => _launchUrl(link),
                  child: Text("Open $title"),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode
            .externalApplication, // Opens the URL in an external browser or app
      );
    } else {
      print("Can launch URL: ${await canLaunchUrl(uri)}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to open: $url")),
      );
    }
  }

  void _showPaymentOptions() {
    final paymentOptions = [
      "WALLET",
      "TOKIPAY",
      "QPAY",
      "HIPAY",
      "MONPAY",
      "GOLOMT",
      "SOCIAL",
      "DIGIPAY"
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: paymentOptions.length,
          itemBuilder: (context, index) {
            final paymentType = paymentOptions[index];
            return ListTile(
              title: Text(paymentType),
              onTap: () {
                Navigator.pop(context); // Close the modal
                _processPayment(paymentType); // Call the API
              },
            );
          },
        );
      },
    );
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
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed:
                            _isProcessingPayment ? null : _showPaymentOptions,
                        child: const Text("Pay Now"),
                      ),
                    ],
                  ),
                )
              : const Center(child: Text("No details found.")),
    );
  }
}
