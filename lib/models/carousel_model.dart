class CarouselModel {
  late String image;
  CarouselModel(this.image);
}

List<CarouselModel> carousels =
    carouselsData.map((item) => CarouselModel(item['image']!)).toList();

var carouselsData = [
  {"image": "assets/images/carousel1.jpg"},
  {"image": "assets/images/carousel2.jpg"},
  {"image": "assets/images/carousel3.jpg"},
];
