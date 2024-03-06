class SecretResponse {
  final bool status;
  final String message;
  final SecretData data;
  final List<dynamic> meta;
  final List<dynamic> pagination;

  SecretResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.meta,
    required this.pagination,
  });

  factory SecretResponse.fromJson(Map<String, dynamic> json) {
    return SecretResponse(
      status: json['status'],
      message: json['message'],
      data: SecretData.fromJson(json['data']),
      meta: json['meta'] ?? [],
      pagination: json['pagination'] ?? [],
    );
  }
}

class SecretData {
  final String secret;

  SecretData({
    required this.secret,
  });

  factory SecretData.fromJson(Map<String, dynamic> json) {
    return SecretData(
      secret: json['secret'],
    );
  }
}
