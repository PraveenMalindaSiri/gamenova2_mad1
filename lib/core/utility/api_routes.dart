class ApiRoutes {
  // main base
  static const String base2 = "192.168.1.100:8000";
  static const String base = "gamenova.duckdns.org";

  //auth
  static const String loginPath = "/api/login";
  static const String registerPath = "/api/register";
  static const String logoutPath = "/api/logout";

  // home/ games
  static const String homePath = "/api/home";
  static const String productsPath = "/api/products";

  // customer
  static const String wishlistPath = "/api/wishlist";
  static const String cartPath = "/api/cart";
  static const String purchasePath = "/api/cart/success";
  static const String orderItemsPath = "/api/orders/items";

  // seller
  static const String sellerProductsPath = "/api/myproducts";
}
