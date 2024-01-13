class Payments {
  String amount;
  String status;
  String packageId;
  String orderId;
  String purchaseTime;
  String purchaseToken;
  String productId;
  String attributeId;
  String hospitalId;
  String subscribedDate;
  String expiredDate;

  Payments(
      {this.amount,
        this.status,
        this.packageId,
        this.orderId,
        this.purchaseTime,
        this.purchaseToken,
        this.productId,
        this.attributeId,
        this.hospitalId,
        this.subscribedDate,
        this.expiredDate});

  Payments.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    status = json['status'];
    packageId = json['package_id'];
    orderId = json['order_id'];
    purchaseTime = json['purchase_time'].toString();
    purchaseToken = json['purchase_token'];
    productId = json['product_id'];
    attributeId = json['attribute_id'];
    hospitalId = json['hospital_id'];
    subscribedDate = json['subscribed_date'];
    expiredDate = json['expired_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['package_id'] = this.packageId;
    data['order_id'] = this.orderId;
    data['purchase_time'] = this.purchaseTime;
    data['purchase_token'] = this.purchaseToken;
    data['product_id'] = this.productId;
    data['attribute_id'] = this.attributeId;
    data['hospital_id'] = this.hospitalId;
    data['subscribed_date'] = this.subscribedDate;
    data['expired_date'] = this.expiredDate;
    return data;
  }
}