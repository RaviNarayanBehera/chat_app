class UserModel {
  String? name, email, image, phone, token;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.token,
    required this.image,
  });

  factory UserModel.fromMap(Map m1) {
    return UserModel(
        name: m1['name'],
        email: m1['email'],
        phone: m1['phone'],
        token: m1['token'],
        image: m1['image']);
  }

  Map<String, String?> toMap(UserModel user)
  {
    return {
      'name' : user.name,
      'email' : user.email,
      'phone' : user.phone,
      'token' : user.token,
      'image' : user.image,
    };
  }
}
