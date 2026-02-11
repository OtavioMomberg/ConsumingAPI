abstract class RemoveItemFromCartRepository {
  Future<void> removeItem(int productId, String accessToken);
}