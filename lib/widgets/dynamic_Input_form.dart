import 'package:flutter/material.dart';
import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/seller.dart'; // Item Model
import 'dart:async';

class DynamicInputForm extends StatefulWidget {
  final String itemId; // ID of the item
  final String inputCheckApi; // API endpoint for input check
  final List<ChargeTemplate> chargeTemplate; // Dynamic input template

  const DynamicInputForm({
    Key? key,
    required this.itemId,
    required this.chargeTemplate,
    required this.inputCheckApi,
  }) : super(key: key);

  @override
  _DynamicInputFormState createState() => _DynamicInputFormState();
}

class _DynamicInputFormState extends State<DynamicInputForm> {
  final ApiClient _apiClient = ApiClient();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String> _dropdownValues = {};
  bool _isLoading = false;
  String _status = "";
  String _message = "";
  bool _buttonState = false;
  bool _loadingChecker = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    for (var template in widget.chargeTemplate) {
      if (template.type == "text") {
        _controllers[template.chargeFieldName!] = TextEditingController()
          ..addListener(() {
            _onInputChanged();
          });
      } else if (template.type == "options" && template.options!.isNotEmpty) {
        _dropdownValues[template.chargeFieldName!] =
            template.options!.first.value ?? "";
      }
    }
  }

  // Debounced Input Checker API Call
  void _onInputChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), _checkInput);
  }

  Future<void> _checkInput() async {
    final Map<String, String> inputValues = {};

    for (var template in widget.chargeTemplate) {
      if (template.type == "text") {
        inputValues[template.chargeFieldName!] =
            _controllers[template.chargeFieldName!]!.text.trim();
      } else if (template.type == "options") {
        inputValues[template.chargeFieldName!] =
            _dropdownValues[template.chargeFieldName!] ?? "";
      }
    }

    if (inputValues.isEmpty || inputValues.values.any((v) => v.isEmpty)) {
      setState(() {
        _status = "";
        _message = "";
        _buttonState = false;
      });
      return;
    }

    try {
      setState(() => _loadingChecker = true);

      final response = await _apiClient.post(
        "${widget.inputCheckApi}/${widget.itemId}",
        inputValues,
      );

      if (response.data['success']) {
        setState(() {
          _status = "success";
          _message =
              response.data['data']['username'] ?? "Validation successful";
          _buttonState = true;
        });
      } else {
        setState(() {
          _status = "danger";
          _message = "Invalid input. Please check and try again.";
          _buttonState = false;
        });
      }
    } catch (e) {
      setState(() {
        _status = "danger";
        _message = "Error occurred during validation.";
        _buttonState = false;
      });
    } finally {
      setState(() => _loadingChecker = false);
    }
  }

  Future<void> _submitOrder() async {
    setState(() => _isLoading = true);

    final Map<String, String> orderInfo = {};
    for (var template in widget.chargeTemplate) {
      if (template.type == "text") {
        orderInfo[template.chargeFieldName!] =
            _controllers[template.chargeFieldName!]!.text.trim();
      } else if (template.type == "options") {
        orderInfo[template.chargeFieldName!] =
            _dropdownValues[template.chargeFieldName!]!;
      }
    }

    final payload = {"order_info": orderInfo, "id": widget.itemId};

    try {
      final response = await _apiClient.post(
        "${ApiConstants.baseUrlSeller}/seller/main/v1/order/",
        payload,
      );

      if (response.data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order created successfully!')),
        );
        Navigator.pop(context);
      } else {
        throw Exception(response.data['message'] ?? "Order creation failed.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Order")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ..._buildDynamicInputs(),
            if (_loadingChecker) const CircularProgressIndicator(),
            if (_status.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _message,
                  style: TextStyle(
                    color: _status == "success" ? Colors.green : Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _buttonState && !_isLoading ? _submitOrder : null,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Submit Order"),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDynamicInputs() {
    return widget.chargeTemplate.map((template) {
      if (template.type == "text") {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: TextField(
            controller: _controllers[template.chargeFieldName],
            decoration: InputDecoration(
              labelText: template.label ?? "Input",
              hintText: template.placeholder,
              border: const OutlineInputBorder(),
            ),
          ),
        );
      } else if (template.type == "options" && template.options != null) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: DropdownButtonFormField<String>(
            value: _dropdownValues[template.chargeFieldName],
            decoration: InputDecoration(
              labelText: template.label ?? "Select Option",
              border: const OutlineInputBorder(),
            ),
            items: template.options!
                .map((option) => DropdownMenuItem(
                      value: option.value,
                      child: Text(option.label ?? "Option"),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _dropdownValues[template.chargeFieldName!] = value ?? "";
              });
            },
          ),
        );
      }
      return const SizedBox.shrink();
    }).toList();
  }
}
