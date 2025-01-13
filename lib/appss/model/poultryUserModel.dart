class PoultryAdminModel {
  final String uid;
  final String name;
  final String farmName;
  final String phone;
  final String email;
  final String address;
  final String createdAt;
 

  PoultryAdminModel({
    required this.uid,
    required this.name,
    required this.farmName,
    required this.phone,
    required this.email,
    required this.address,
    required this.createdAt,
 
  });

  factory PoultryAdminModel.fromJson(Map<String, dynamic> json) {
    return PoultryAdminModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      farmName: json['farmName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      createdAt: json['createdAt'] ?? '',
 
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'farmName': farmName,
    'phone': phone,
    'email': email,
    'address': address,
    'createdAt': createdAt,
 
  };
}