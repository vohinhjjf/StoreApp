class FlashSaleModel {
  final bool mall;
  final int discountPercentage;
  final String image;
  final String name;
  final double price;
  final int qty;
  final int sold;

  FlashSaleModel({
    this.mall = false,
    this.price = 0.0,
    this.discountPercentage = 0,
    required this.image,
    required this.name,
    this.qty = 0,
    this.sold = 0,
  });
}
