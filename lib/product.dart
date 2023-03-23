
class Product {
  int id;
  String name;
  int price;
  int count;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.count});

  factory Product.fromJSON(Map<dynamic, dynamic> json) {
    return Product(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        price: json["price"] ?? 0,
        count: json["count"] ?? 0);
  }

 Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data["count"] = count;
    return data;
  }
}
