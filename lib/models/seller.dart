class Product {
  final String? id; // Product ID
  final String? name; // Product name
  final String? nameEn; // Product name in English
  final List<String>? categoryId; // Category IDs
  final String? product3rdId; // Third-party product ID
  final String? logo; // Logo image
  final String? banner; // Banner image
  final String? bannerMini; // Mini banner image
  final List<String>? screenshots; // Screenshots
  final String? video; // Video URL
  final String? description; // Product description
  final String? item; // Item name
  final String? search; // Search field
  final String? keyboard; // Input keyboard type
  final String? paidCallbackUrl; // Paid callback URL
  final int? discount; // Discount percentage
  final String? productType; // Product type (CARD or RECHARGE)
  final List<String>? showChannels; // Supported channels
  final String? helperUrl; // Helper URL
  final String? inputDesc; // Input description
  final String? inputCheckApi; // Input check API
  final List<String>? inputNames; // Input field names
  final int? orderIndex; // Order index
  final bool? active; // Active status
  final bool? show; // Show status
  final bool? delFlg; // Delete flag
  final String? createdAt; // createdAt
  final String? updatedAt; // createdAt   final String? createdAt; // createdAt
  Product({
    this.id,
    this.name,
    this.nameEn,
    this.categoryId,
    this.product3rdId,
    this.logo,
    this.banner,
    this.bannerMini,
    this.screenshots,
    this.video,
    this.description,
    this.item,
    this.search,
    this.keyboard,
    this.paidCallbackUrl,
    this.discount,
    this.productType,
    this.showChannels,
    this.helperUrl,
    this.inputDesc,
    this.inputCheckApi,
    this.inputNames,
    this.orderIndex,
    this.active,
    this.show,
    this.delFlg,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      nameEn: json['name_en'],
      categoryId: List<String>.from(json['category_id'] ?? []),
      product3rdId: json['product_3rd_id'],
      logo: json['logo'],
      banner: json['banner'],
      bannerMini: json['banner_mini'],
      screenshots: List<String>.from(json['screenshots'] ?? []),
      video: json['video'],
      description: json['description'],
      item: json['item'],
      search: json['search'],
      keyboard: json['keyboard'],
      paidCallbackUrl: json['paid_callback_url'],
      discount: json['discount'],
      productType: json['product_type'],
      showChannels: List<String>.from(json['show_chanels'] ?? []),
      helperUrl: json['helper_url'],
      inputDesc: json['input_desc'],
      inputCheckApi: json['input_check_api'],
      inputNames: List<String>.from(json['input_names'] ?? []),
      orderIndex: json['order_index'],
      active: json['active'],
      show: json['show'],
      delFlg: json['delFlg'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  // Method to convert Product object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'category_id': categoryId,
      'product_3rd_id': product3rdId,
      'logo': logo,
      'banner': banner,
      'banner_mini': bannerMini,
      'screenshots': screenshots,
      'video': video,
      'description': description,
      'item': item,
      'search': search,
      'keyboard': keyboard,
      'paid_callback_url': paidCallbackUrl,
      'discount': discount,
      'product_type': productType,
      'show_chanels': showChannels,
      'helper_url': helperUrl,
      'input_desc': inputDesc,
      'input_check_api': inputCheckApi,
      'input_names': inputNames,
      'order_index': orderIndex,
      'active': active,
      'show': show,
      'delFlg': delFlg,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}

class Item {
  // Default fields
  final String? id;
  final String? item3rdId;
  final String? productId;
  final String? currencyId;
  final String? name;
  final String? nameAmount;
  final String? nameItem;
  final num? amount;
  final num? profit;
  final bool? profitType;
  final String? image;
  final num? discount;
  final int? orderIndex;

  // Charge Template
  final List<ChargeTemplate>? chargeTemplate;

  // Status fields
  final bool? stockOut;
  final bool? active;
  final bool? show;
  final bool? delFlg;

  // Created and Updated dates
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Constructor
  Item({
    this.id,
    this.item3rdId,
    this.productId,
    this.currencyId,
    this.name,
    this.nameAmount,
    this.nameItem,
    this.amount,
    this.profit,
    this.profitType,
    this.image,
    this.discount,
    this.orderIndex,
    this.chargeTemplate,
    this.stockOut,
    this.active,
    this.show,
    this.delFlg,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON into the model
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      item3rdId: json['item_3rd_id'],
      productId: json['product_id'],
      currencyId: json['currency_id'],
      name: json['name'],
      nameAmount: json['name_amount'],
      nameItem: json['name_item'],
      amount: json['amount'],
      profit: json['profit'],
      profitType: json['profit_type'],
      image: json['image'],
      discount: json['discount'],
      orderIndex: json['order_index'],
      chargeTemplate: (json['charge_template'] as List<dynamic>?)
          ?.map((e) => ChargeTemplate.fromJson(e))
          .toList(),
      stockOut: json['stock_out'],
      active: json['active'],
      show: json['show'],
      delFlg: json['delFlg'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

// Charge Template Model
class ChargeTemplate {
  final String? chargeFieldName;
  final String? label;
  final String? placeholder;
  final int? sortOrder;
  final bool? multiline;
  final String? prefix;
  final String? type;
  final List<ChargeOption>? options;

  ChargeTemplate({
    this.chargeFieldName,
    this.label,
    this.placeholder,
    this.sortOrder,
    this.multiline,
    this.prefix,
    this.type,
    this.options,
  });

  factory ChargeTemplate.fromJson(Map<String, dynamic> json) {
    return ChargeTemplate(
      chargeFieldName: json['charge_field_name'],
      label: json['label'],
      placeholder: json['placeholder'],
      sortOrder: json['sortord'],
      multiline: json['multiline'],
      prefix: json['prefix'],
      type: json['type'],
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => ChargeOption.fromJson(e))
          .toList(),
    );
  }
}

// Charge Option Model
class ChargeOption {
  final String? label;
  final String? value;
  final int? id;

  ChargeOption({
    this.label,
    this.value,
    this.id,
  });

  factory ChargeOption.fromJson(Map<String, dynamic> json) {
    return ChargeOption(
      label: json['label'],
      value: json['value'],
      id: json['id'],
    );
  }
}

class Order {
  final String? orderId;
  final int? userId;
  final String? userType;
  final String? productId;
  final String? itemId;
  final String? transactionId;
  final String? orderEmail;
  final int? orderPhoneNumber;
  final Map<String, dynamic>? orderInfo;
  final String? status;
  final double? amount;
  final double? paidAmount;
  final double? refundAmount;
  final String? paidType;
  final String? createdDate;

  Order({
    this.orderId,
    this.userId,
    this.userType,
    this.productId,
    this.itemId,
    this.transactionId,
    this.orderEmail,
    this.orderPhoneNumber,
    this.orderInfo,
    this.status,
    this.amount,
    this.paidAmount,
    this.refundAmount,
    this.paidType,
    this.createdDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'],
      userId: json['user_id'],
      userType: json['user_type'],
      productId: json['product_id'],
      itemId: json['item_id'],
      transactionId: json['transaction_id'],
      orderEmail: json['order_email'],
      orderPhoneNumber: json['order_phone_number'],
      orderInfo: json['order_info'],
      status: json['status'],
      amount: json['amount']?.toDouble(),
      paidAmount: json['paid_amount']?.toDouble(),
      refundAmount: json['refund_amount']?.toDouble(),
      paidType: json['paid_type'],
      createdDate: json['created_date'],
    );
  }
}
