import 'package:store/features/products/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.title,
    required super.category,
    required super.price,
    required super.image,
    required super.description,
    required super.rating,
    required super.ratingCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      rating: (json['rating']?['rate'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['rating']?['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'price': price,
      'image': image,
      'description': description,
      'rating': {
        'rate': rating,
        'count': ratingCount,
      },
    };
  }
}
