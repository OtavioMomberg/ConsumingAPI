enum AuthEnum {
  authenticated,
  notAuthenticated,
}

class MapAuthEnum {
  static String mapper(AuthEnum option) {
    return option == AuthEnum.authenticated ? "Authenticated" : "NotAuthenticated";
  }
}