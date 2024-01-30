class Product {

  Product({
    required this.productName,
    required this.videoUrl,
    required this.description,
    required this.testimonials,
    required this.affiliateProducts,
    required this.price
  });
  String productName;
  String videoUrl;
  String description;
  List<dynamic> testimonials;
  List<dynamic> affiliateProducts;
  double price;
}
