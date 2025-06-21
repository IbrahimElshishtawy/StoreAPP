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
  // this method is used to convert the product object to a map
  // which is uded to send data to the server or save it in loacal storage
  factory Product_model.fromJson(Map<String, dynamic> json) {
    return Product_model(
      id: json['id'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      imageUrl: json['image'] as String?,
      rating: rating_model.fromJson(
        json['rating'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

// class map rating_model is using to convert the rating object to a map
// which is used to send data to the server or save it in local storage
class rating_model {
  final String? rate;
  final String? count;
  // Assuming you might want to include count as well

  rating_model({required this.rate, required this.count});

  factory rating_model.fromJson(Map<String, dynamic> json) {
    return rating_model(
      rate: json['rate'] as String?,
      count: json['count'] as String?,
    );
  }
}
