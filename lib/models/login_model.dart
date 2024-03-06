class UserDetails {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String? phone;
  final String? phoneCountry;
  final String country;
  final String? avatar;

  UserDetails({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    required this.phoneCountry,
    required this.country,
    required this.avatar,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return UserDetails(
      id: user['id'],
      fullName: user['full_name'],
      username: user['username'] ?? '', // assuming username is optional
      email: user['email'],
      phone: user['phone'] ?? '',
      phoneCountry: user['phone_country'] ?? '',
      country: user['country'],
      avatar: user['avatar'] ??'',
    );
  }
}

class UserData {
  final UserDetails userDetails;
  final String token;

  UserData({required this.userDetails, required this.token});

  factory UserData.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return UserData(
      userDetails: UserDetails.fromJson(data['user']),
      token: data['token'],
    );
  }
}

class UserModel {
  final bool status;
  final String message;
  final UserData data;

  UserModel({required this.status, required this.message, required this.data});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'],
      message: json['message'],
      data: UserData.fromJson(json),
    );
  }
}
