import 'package:flutter/material.dart';
import 'package:smartpay/models/secret_message_model.dart';
import '../services/home_service.dart';

class SecretProvider extends ChangeNotifier {
  final SecretService _secretService = SecretService();
  late String _token;

  void setToken(String token) {
    _token = token;
  }

String? secretMessage;

Future<void> fetchSecret(String token) async {
  final responseData = await _secretService.getMessage(_token);
  if (responseData != null) {
    // Update secret message if the response is successful
    secretMessage = responseData['data']['secret'];
    notifyListeners();
  }
}

}
