class OrderModel {
  final String id;
  final String phone;
  final String address;
  final String userId;
  final String ownerId;
  final String status;
  final double total;
  final String productId;
  final DateTime createdAt;

  OrderModel({
    required this.ownerId,
    required this.productId,
    required this.id,
    required this.phone,
    required this.address,
    required this.userId,
    required this.status,
    required this.total,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'phone': phone,
      'address': address,
      'userId': userId,
      'status': status,
      'total': total,
      'createdAt': createdAt,
      'ownerId': ownerId,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      productId: map['productId'] ?? '',
      id: map['id'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      ownerId: map['ownerId'] ?? '',
      userId: map['userId'] ?? '',
      status: map['status'] ?? "Pending",
      total: map['total'] ?? 10.0,
      createdAt: map['createdAt'].toDate() ?? DateTime.now(),
    );
  }

  OrderModel copyWith(
      {String? id,
      String? phone,
      String? name,
      String? address,
      String? paymentMethod,
      String? userId,
      String? status,
      double? total,
      DateTime? createdAt,
      String? productId,
      String? ownerId}) {
    return OrderModel(
      productId: productId ?? this.productId,
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
