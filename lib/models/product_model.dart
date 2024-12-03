import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String title;
  String description;
  String imageUrl;
  double price;
  DateTime createdAt;
  String location;
  String id;
  String userId;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.createdAt,
    required this.location,
    required this.userId,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
        title: map['title'],
        description: map['description'],
        imageUrl: map['imageUrl'],
        price: map['price'],
        createdAt: (map['createdAt'] as Timestamp).toDate(),
        location: map['location'],
        id: map['id'],
        userId: map['userId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'createdAt': Timestamp.fromDate(createdAt),
      'location': location,
      'id': id,
      'userId': userId,
    };
  }

  ProductModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    double? price,
    DateTime? createdAt,
    String? location,
    String? userId,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      location: location ?? this.location,
      userId: userId ?? this.userId,
    );
  }
}
