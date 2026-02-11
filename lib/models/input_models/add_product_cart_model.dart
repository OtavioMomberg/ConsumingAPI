class AddProductCartModel {
  int productId;
  int quantity;

  AddProductCartModel({
    required this.productId,
    required this.quantity,
  });

  Map<String, int> toJson() {
    return {
      "product_id" : productId,
      "quantity" : quantity,
    };
  }
}