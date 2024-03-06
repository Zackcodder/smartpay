import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartpay/provider/auth_provider.dart';
import 'package:smartpay/provider/home_provider.dart';
import 'package:smartpay/screens/landing_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('auth_token');
  final String? userName = prefs.getString('user_name');
  final String? userLastName = prefs.getString('user_lastname');
  final String? userEmail = prefs.getString('user_email');
  final String? userImage = prefs.getString('user_image');
  final String? phoneNumber = prefs.getString('phone_number');
  final String? id = prefs.getString('user_id');
  runApp(MyApp(token, userName, userEmail, userLastName, userImage, phoneNumber, id));
}

class MyApp extends StatelessWidget {
  // static final GlobalKey<NavigatorState> navigatorKey =
  // GlobalKey<NavigatorState>();
  final String? initialToken;
  final String? initialuserName;
  final String? initialuserLastName;
  final String? initialuserEmail;
  final String? initialuserImage;
  final String? initialphoneNumber;
  final String? initialId;
  const MyApp(
      this.initialToken,
      this.initialuserEmail,
      this.initialuserLastName,
      this.initialuserName,
      this.initialuserImage,
      this.initialphoneNumber,
      this.initialId,
      {Key? key})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      ensureScreenSize: true,
      builder: (_, __) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => AuthProvider(
                  initialuserName,
                  initialuserEmail,
                  initialuserLastName,
                  initialToken,
                  initialuserImage,
                  initialphoneNumber, initialId,),
              ),
              ChangeNotifierProvider(create: (context) => SecretProvider()),

            ],
            child: MaterialApp(
              title: 'SmartPay',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: const LandingScreen(),
            ),
          );
        }
    );
  }
}
