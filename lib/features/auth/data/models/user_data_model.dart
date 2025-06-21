class UserDataModel {
  String id;
  String name;
  String email;
  String password;
  String phone;
  String ?token;

  UserDataModel({
    this.id = '-1',
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    this.token,
  });

  factory UserDataModel.fromJson(dynamic json) {
    return UserDataModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'] ?? " ",
      phone: json['phone'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'token':token,
    };
  }
}
