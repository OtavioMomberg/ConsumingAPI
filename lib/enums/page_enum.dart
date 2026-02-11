enum PageEnum {
  nullPage,
  cartPage
}

class PageNumberEnum {
  static final Map<PageEnum, int> pageNumber = {
    PageEnum.nullPage : 0,
    PageEnum.cartPage : 1,
  };

  static int mapper(PageEnum page) {
    return pageNumber[page]!;
  }
}