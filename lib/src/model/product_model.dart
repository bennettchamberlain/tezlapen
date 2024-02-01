import 'package:flutter/foundation.dart';

import 'package:tezlapen_v2/src/model/affiliate_model.dart';

import 'package:tezlapen_v2/src/model/testimonial_model.dart';

class Product {
  Product({
    required this.productName,
    required this.videoUrl,
    required this.description,
    required this.testimonials,
    required this.affiliate,
    required this.price,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productName: map['productName'] as String,
      videoUrl: map['videoUrl'] as String,
      description: map['description'] as String,
      testimonials: List<Testimonial>.from(
        (map['testimonials'] as List<dynamic>).map<Testimonial>(
          (x) => Testimonial.fromMap(x as Map<String, dynamic>),
        ),
      ),
      affiliate: List<Affiliate>.from(
        (map['affiliate'] as List<dynamic>).map<Affiliate>(
          (x) => Affiliate.fromMap(x as Map<String, dynamic>),
        ),
      ),
      price: map['price'] as double,
    );
  }
  final String productName;
  final String videoUrl;
  final String description;
  final List<Testimonial> testimonials;
  final List<Affiliate> affiliate;
  final double price;

  Product copyWith({
    String? productName,
    String? videoUrl,
    String? description,
    List<Testimonial>? testimonials,
    List<Affiliate>? affiliate,
    double? price,
  }) {
    return Product(
      productName: productName ?? this.productName,
      videoUrl: videoUrl ?? this.videoUrl,
      description: description ?? this.description,
      testimonials: testimonials ?? this.testimonials,
      affiliate: affiliate ?? this.affiliate,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productName': productName,
      'videoUrl': videoUrl,
      'description': description,
      'testimonials': testimonials.map((x) => x.toMap()).toList(),
      'affiliate': affiliate.map((x) => x.toMap()).toList(),
      'price': price,
    };
  }

  @override
  String toString() {
    return 'Product(productName: $productName, videoUrl: $videoUrl, description: $description, testimonials: $testimonials, affiliate: $affiliate, price: $price)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.productName == productName &&
        other.videoUrl == videoUrl &&
        other.description == description &&
        listEquals(other.testimonials, testimonials) &&
        listEquals(other.affiliate, affiliate) &&
        other.price == price;
  }

  @override
  int get hashCode {
    return productName.hashCode ^
        videoUrl.hashCode ^
        description.hashCode ^
        testimonials.hashCode ^
        affiliate.hashCode ^
        price.hashCode;
  }
}
