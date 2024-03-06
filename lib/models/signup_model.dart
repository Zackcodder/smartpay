class SignUpResponse {
  final bool status;
  final String message;
  final Data data;

  SignUpResponse({required this.status, required this.message, required this.data});

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      status: json['status'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  final String token;

  Data({required this.token});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      token: json['token'],
    );
  }
}
