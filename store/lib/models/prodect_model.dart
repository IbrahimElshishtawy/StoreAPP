// ignore_for_file: camel_case_types

class Product_model {
  final String id;
  final String? title;
  final String? description;
  final double? price;
  final String? imageUrl;
  final rating_model? rating;

  Product_model({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });

  factory Product_model.fromJson(Map<String, dynamic> json) {
    return Product_model(
      id: json['id'].toString(), // ✅ هنا التعديل
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      imageUrl: json['image'] as String?,
      rating: json['rating'] != null
          ? rating_model.fromJson(json['rating'] as Map<String, dynamic>)
          : null,
    );
  }
}

class rating_model {
  final double rate;
  final int count;

  rating_model({required this.rate, required this.count});

  factory rating_model.fromJson(Map<String, dynamic> json) {
    return rating_model(
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      count: (json['count'] as int?) ?? 0,
    );
  }
}
