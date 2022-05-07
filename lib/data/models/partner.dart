class Partner {
  String id;
  String fcmToken;
  String name;
  List<String> orders;

  Partner.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        fcmToken = data['fcm_token'],
        name = data['name'],
        orders = List<String>.from(data['orders']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fcm_token': fcmToken,
      'name': name,
      'orders': orders,
    };
  }
}