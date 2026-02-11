enum TokenType {
  accessToken,
  refreshToken,
}

class TokenTypeEnum {
  static String mapper(TokenType type) {
    return type == TokenType.accessToken ? "access_token" : "refresh_token";
  }
}