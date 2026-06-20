import 'package:store/features/products/domain/entities/product_entity.dart';

class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final String category;
  final double rating;
  final int ratingCount;
  final bool isPromoted;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.rating,
    required this.ratingCount,
    required this.isPromoted,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, [String? docId]) {
    return ProductModel(
      id: docId ?? json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      rating: (json['rating']?['rate'] as num?)?.toDouble() ??
              (json['rating'] is num ? (json['rating'] as num).toDouble() : 0.0),
      ratingCount: json['rating']?['count'] ?? 0,
      isPromoted: json['isPromoted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'rating': {'rate': rating, 'count': ratingCount},
      'isPromoted': isPromoted,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      title: title,
      description: description,
      price: price,
      image: image,
      category: category,
      rating: rating,
      ratingCount: ratingCount,
      isPromoted: isPromoted,
    );
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      image: entity.image,
      category: entity.category,
      rating: entity.rating,
      ratingCount: entity.ratingCount,
      isPromoted: entity.isPromoted,
    );
  }
}
