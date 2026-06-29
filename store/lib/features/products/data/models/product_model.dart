// ignore_for_file: file_names

class ProductModel {
  final String id;
  final String? title;
  final String? description;
  final String? category;
  final double? price;
  final String? imageUrl;
  final RatingModel? rating;
  final bool? isPromoted;
  final bool? hasVr;
  final String? dealTag;
  final double? originalPrice;
  final String? arModelUrl;

  ProductModel({
    required this.id,
    this.title,
    this.description,
    this.category,
    this.price,
    this.imageUrl,
    this.rating,
    this.isPromoted,
    this.hasVr,
    this.dealTag,
    this.originalPrice,
    this.arModelUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      imageUrl: json['image'] as String?,
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : null,
      isPromoted: json['isPromoted'] as bool?,
      hasVr: json['hasVr'] as bool?,
      dealTag: json['dealTag'] as String?,
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      arModelUrl: json['arModelUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'image': imageUrl,
      'rating': rating?.toJson(),
      'isPromoted': isPromoted,
      'hasVr': hasVr,
      'dealTag': dealTag,
      'originalPrice': originalPrice,
      'arModelUrl': arModelUrl,
    };
  }

  ProductModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    double? price,
    String? imageUrl,
    RatingModel? rating,
    bool? isPromoted,
    bool? hasVr,
    String? dealTag,
    double? originalPrice,
    String? arModelUrl,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      isPromoted: isPromoted ?? this.isPromoted,
      hasVr: hasVr ?? this.hasVr,
      dealTag: dealTag ?? this.dealTag,
      originalPrice: originalPrice ?? this.originalPrice,
      arModelUrl: arModelUrl ?? this.arModelUrl,
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
