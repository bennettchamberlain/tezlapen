class Product {

  Product({
    required this.productName,
    required this.videoUrl,
    required this.description,
    required this.testimonials,
    required this.affiliateProducts,
  });
  String productName;
  String videoUrl;
  String description;
  List<dynamic> testimonials;
  List<dynamic> affiliateProducts;
}
