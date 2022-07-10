class OrderModel{
  String? addressID;
  num? totalAmount;
  String? orderBy;
  String? paymentMethod;
  String? orderTime;
  bool isSuccess =  true;
  String? sellerUID;
  String? riderUID =  "";
  String? status = "normal";
  String? orderId;
  int? discount;
  int? deliveryCharge;
  int? vat;
  // String? paymentDetails = "Cash on Delivery";
  
  OrderModel({
      this.addressID,
      this.totalAmount,
      this.orderBy,
      this.paymentMethod,
      this.orderTime,
      required this.isSuccess,
      this.sellerUID,
      this.riderUID,
      this.status,
      this.orderId,
      this.deliveryCharge,
      this.vat,
      this.discount,});

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      "orderId": orderId,
      "addressID": addressID,
      "totalAmount": totalAmount,
      "orderBy": orderBy,
      "paymentMethod": paymentMethod,
      "orderTime": orderTime,
      "isSuccess": isSuccess,
      "sellerUID": sellerUID,
      "riderUID": riderUID,
      "status": status,
      "deliveryCharge": deliveryCharge,
      "vat": vat,
      "discount": discount,
    };
    return map;
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
    addressID: map['addressID'],
    totalAmount: map['totalAmount'],
    orderBy: map['orderBy'],
    paymentMethod: map['paymentMethod'],
    orderTime: map['orderTime'],
    isSuccess: map['isSuccess'],
    sellerUID: map['sellerUID'],
    riderUID: map['riderUID'],
    status: map['status'],
    orderId: map['orderId'],
    deliveryCharge: map['deliveryCharge'],
    vat: map['vat'],
    discount: map['discount'],
  );
}