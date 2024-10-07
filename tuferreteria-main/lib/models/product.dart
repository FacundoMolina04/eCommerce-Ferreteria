class Product {
  String name;
  double price;
  String image;
  String description;
  int id;
  int ? stock;  

  Product({required this.id, required this.name, required this.price, required this.image, required this.description, this.stock});  // Actualizado el constructor

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      description: json['description'],
      stock: json['stock'],  
    );
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'description': description,
      'stock': stock,  
    };
  }
}