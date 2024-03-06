import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final String baseUrl = 'https://mobile-test-2d7e555a4f85.herokuapp.com';

  ///login function
  signIn(String email, String password,String deviceId) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    var response = await https.post(
      Uri.parse('$baseUrl/api/v1/auth/login'),
      body: jsonEncode({'email': email,
        'password': password,
        'device_name': deviceId}),
      headers: headers,
    );
    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200 && responseData['message'] == 'success') {
      return responseData;
    } else {
      throw Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: responseData['message'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
    }
  }

  /// signup function
  signUp(String email) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    var response = await https.post(
      Uri.parse('$baseUrl/api/v1/auth/email'),
      body: jsonEncode({
        'email': email,
      }),
      headers: headers,
    );
    final responseData = jsonDecode(response.body);
    print('this is the response $responseData');
    if (response.statusCode == 200 && responseData['message'] == 'success') {
      Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black.withOpacity(0.7),
          msg: 'This is your token ${responseData['data']['token']}',
          gravity: ToastGravity.CENTER,
          textColor: Colors.white);
      return responseData;
    } else {
      throw Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: responseData['message'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
    }
  }

  ///sending of otp
  sendOtp(String email,String otp) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    var response = await https.post(
      Uri.parse('$baseUrl/api/v1/auth/email/verify'),
      body: jsonEncode({
        'email': email,
        'token': otp,
      }),
      headers: headers,
    );
    final responseData = jsonDecode(response.body);
    print('this is the response &responseData');
    if ( responseData['message'] == 'success') {
      Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.green.withOpacity(0.7),
          msg: responseData['message'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
      return responseData;
    } else {
      throw Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: responseData['message'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
    }
  }


  ///registration function
  register(String fullName, String userName, String email,
      String country,String password, String deviceId) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    var response = await https.post(
      Uri.parse('$baseUrl/api/v1/auth/register'),
      body: jsonEncode({
        'full_name': fullName,
        'username': userName,
        'email': email,
        'country': country,
        'password': password,
        'device_name': deviceId,
      }),
      headers: headers,
    );
    final responseData = jsonDecode(response.body);
    if (responseData['message'] == 'success') {
      Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.green.withOpacity(0.7),
          msg: responseData['message'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
      return responseData;
    } else {
      throw Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: responseData['message'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
    }
  }

}
