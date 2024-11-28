class UserModel {
  final dynamic email;
  final dynamic name;
  final dynamic imgUrl;
  final dynamic description;
  final dynamic phone;
  final dynamic id;

  UserModel({
    required this.email,
    required this.name,
    required this.imgUrl,
    required this.description,
    required this.phone,
    required this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      imgUrl: json['imgUrl'] ?? '',
      description: json['description'] ?? '',
      phone: json['phone'] ?? '',
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'imgUrl': imgUrl,
      'description': description,
      'phone': phone,
      'id': id,
    };
  }
}
