// ignore_for_file: file_names

class ProductModel {
  final String id;
  final String? title;
  final String? description;
  final String? category;
  final double? price;
  final String? imageUrl;
  final RatingModel? rating;
  final bool isPromoted;

  ProductModel({
    required this.id,
    this.category,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.rating,
    this.isPromoted = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      category: json['category'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      imageUrl: json['image'] as String?,
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : null,
      isPromoted: json['isPromoted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'description': description,
      'price': price,
      'image': imageUrl,
      'rating': rating?.toJson(),
      'isPromoted': isPromoted,
    };
  }

  ProductModel copyWith({
    String? id,
    String? category,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    RatingModel? rating,
    bool? isPromoted,
  }) {
    return ProductModel(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      isPromoted: isPromoted ?? this.isPromoted,
    );
  }
}

class RatingModel {
  final double rate;
  final int count;

  RatingModel({required this.rate, required this.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      count: json['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'rate': rate, 'count': count};
  }
}
