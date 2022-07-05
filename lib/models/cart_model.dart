class CartModel {
  String? itemID;
  String? itemTitle;
  String? shortInformation;
  num? price;
  String? itemImageUrl;
  int quantity = 1;
  String? sellerId;

  CartModel({
    this.itemID,
    this.shortInformation,
    this.itemTitle,
    this.price,
    this.itemImageUrl,
    this.quantity = 1,
    this.sellerId,
  });

   CartModel.fromMap(Map<String, dynamic> map) {
    itemID = map['itemID'];
    shortInformation = map['shortInformation'];
    itemTitle = map['itemTitle'];
    price = map['price'];
    itemImageUrl = map['itemImageUrl'];
    quantity =  map['quantity'];
    sellerId = map['sellerId'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map["itemID"] = itemID;
    map["shortInformation"] = shortInformation;
    map["itemTitle"] = itemTitle;
    map["price"] = price;
    map["itemImageUrl"] = itemImageUrl;
    map["quantity"] = quantity;
    map["sellerId"] = sellerId;
    return map;
  }
}
