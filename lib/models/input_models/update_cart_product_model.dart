class UpdateCartProductModel {
  int productId;
  int quantity;

  UpdateCartProductModel({
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