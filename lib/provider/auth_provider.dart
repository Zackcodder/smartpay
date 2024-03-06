import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartpay/provider/home_provider.dart';
import 'package:smartpay/screens/otp_screen.dart';
import 'package:smartpay/screens/registration_screen.dart';
import 'package:smartpay/screens/success_screen.dart';

import '../models/login_model.dart';
import '../models/signup_model.dart';
import '../screens/home_screen.dart';
import '../services/auth_services.dart';

class AuthProvider with ChangeNotifier {
  bool _signInLoading = false;
  bool get signInLoading => _signInLoading;
  bool _signUpLoading = false;
  bool get signUpLoading => _signUpLoading;
  UserModel? _user;
  UserModel? get user => _user;
  SignUpResponse? _userSignUp;
  SignUpResponse? get userSignUp => _userSignUp;
  String? _userName;
  String? get userName => _userName;
  String? _userEmail;
  String? get userEmail => _userEmail;
  String? _userLastName;
  String? get userLastName => _userLastName;
  String? _userImage;
  String? get userImage => _userImage;
  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;
  String? _error;
  String? get error => _error;
  String? _token;
  String? get token => _token;
  String? _id;
  String? get id => _id;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final AuthService _authService = AuthService();

  final SecretProvider _secretProvider = SecretProvider();

  setError(String message) {
    _error = message;
    notifyListeners();
  }

  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //load the token and user name from the storage

  AuthProvider(String? userName, String? userLastName, String? userEmail,
      String? token, String? userImage, String? phoneNumber, String? id) {
    _userName = userName;
    _userEmail = userEmail;
    _userLastName = userLastName;
    _userImage = userImage;
    _phoneNumber = phoneNumber;
    _token = token;
    _id = id;
  }

  //save the user information data
  saveuserData(String userEmail, String userName, String userLastName,
      String token, String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_email', userEmail);
    await prefs.setString('user_name', userName);
    await prefs.setString('user_lastname', userLastName);
    await prefs.setString('user_id', id);
    notifyListeners();
  }

  ///login function
  signIn(BuildContext context, String email, String password, String deviceId) async {
    _signInLoading = true;
    final responseData = await _authService.signIn(email, password, deviceId);

    if (responseData['status']) {
      // Status is true, indicating successful login
      final data = responseData['data'];
      final userDetails = data['user'];
      final token = data['token'];

      _userName = userDetails['username'];
      _userEmail = userDetails['email'];
      _userLastName = userDetails['full_name'];
      _token = token;
      _userImage = userDetails['avatar'];
      _phoneNumber = userDetails['phone'];
      _id = userDetails['id'];

      await saveuserData(_userEmail!, _userName??'', _userLastName!, _token!, _id!);
      _secretProvider.setToken(token);
      // _secretProvider.fetchSecret();

      // Navigate to home page
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    } else {
      // Status is false, indicating login failure
      setError(responseData['message']);
    }

    _signInLoading = false;
    notifyListeners();
  }

  /// SignUp
  signUp(BuildContext context, String email) async {
    _signUpLoading = true;
    final responseData = await _authService.signUp(email);

    if (responseData['status']) {
      // Status is true, indicating success
      final data = responseData['data'];
      final token = data['token'];
      final userDetails = data['user'];
      _userEmail = email;
      _signUpLoading = false;
      notifyListeners();


      // Navigate to OTP screen
      Future.delayed(Duration.zero, () {
        if (email.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OtpScreen(),
            ),
          );
        }
      });
    } else {
      notifyListeners();
      _signUpLoading = false;
      // Status is false, indicating failure
      // setError(responseData['message']);
    }

    // _signUpLoading = false;
    // notifyListeners();
  }

  ///sending of otp
  sendOtp(BuildContext context,String email, String otp) async {
    _signUpLoading = true;
    final responseData = await _authService.sendOtp(email,otp);

    if (responseData['message'] == 'success') {
      // navigate to otp page
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RegistrationScreen()),
        );
      });
      _signUpLoading = false;
    } else {
      setError(responseData['message']);
      _signUpLoading = false;
    }
    _signUpLoading = false;
  }

  ///resgister function
  register(BuildContext context, String fullName, String userName, String email,
      String country, password, String deviceId) async {
    _signUpLoading = true;
    final responseData = await _authService.register(
        fullName, userName, email, country, password, deviceId);

    final signUpResponse = SignUpResponse.fromJson(responseData);
    if (signUpResponse.message == 'success') {
      _userLastName = fullName;
      //navigate to home page
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SuccessScreen()),
        );
      });
      _signUpLoading = false;
      notifyListeners();
    } else {
      _signUpLoading = false;
      setError(responseData['message']);
      notifyListeners();
    }
    _signUpLoading = false;
    notifyListeners();
  }


}
