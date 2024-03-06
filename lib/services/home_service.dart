import 'dart:convert';
import 'package:http/http.dart' as https;

class SecretService {
  final String baseUrl =
      'https://mobile-test-2d7e555a4f85.herokuapp.com/api/v1/';

  Future<Map<String, dynamic>?> getMessage(String token) async {
    try {
      final response = await https.get(
        Uri.parse(baseUrl + 'dashboard'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final responseData = jsonDecode(response.body);
        if (responseData['message'] == 'success') {
          return responseData;
        } else {
          // Handle error if the response message is not success
          return null;
        }
      } else {
        // Handle HTTP error status codes
        return null;
      }
    } catch (e) {
      // Handle exceptions
      return null;
    }
  }
}
