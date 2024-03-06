import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smartpay/core/extension/build_context_extensions.dart';
import 'package:smartpay/core/extension/widget_extensions.dart';
import 'package:smartpay/screens/signup_screen.dart';

import 'package:device_info_plus/device_info_plus.dart';
import '../core/constant/colors.dart';
import '../provider/auth_provider.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_text_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/spacing.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String deviceId = '';

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final AndroidDeviceInfo androidInfo =
            await deviceInfoPlugin.androidInfo;
        deviceId = androidInfo.id;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        // Handle iOS device info here if needed.
        final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iosInfo.model;
      }
    } catch (e) {
      return;
    }

    return deviceId;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          child: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.offWhite),
                        color: AppColors.white,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                  const VerticalSpacing(20),

                  ///welcome text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Hi There!',
                        textAlign: TextAlign.justify,
                        style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'SFPRODISPLAYBOLD',
                            fontSize: 24,
                            color: AppColors.black),
                      ),
                      Image.asset(
                        'assets/handwave.png',
                        height: 50,
                        width: 50,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, Sign in to your account',
                        textAlign: TextAlign.justify,
                        style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'SFPRODISPLAYREGULAR',
                            fontSize: 16,
                            color: AppColors.landingSubtextColor),
                      ),
                    ],
                  ),
                  const VerticalSpacing(40),

                  ///email field
                  AppTextField(
                    hintText: 'Email',
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      // Check for email format using regex
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Invalid email format';
                      }
                      return null; // Return null if validation passes
                    },
                  ),
                  const VerticalSpacing(20),

                  ///password field
                  AppTextField(
                    hintText: 'Password',
                    controller: passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      // Check for password complexity requirements
                      if (!RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$')
                          .hasMatch(value)) {
                        return 'Password must contain at least one uppercase letter, one lowercase letter, one number, and be at least 6 characters long';
                      }
                      return null; // Return null if validation passes
                    },
                  ),
                  const VerticalSpacing(10),

                  ///forget password
                  AppTextButton(
                    onPressed: () {},
                    text: 'Forgot Password?',
                  ),

                  ///login button
                  authProvider.signInLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          ),
                        )
                      : AppElevatedButton.large(
                          onPressed: () async {
                            setState(() {});

                            /// Get device ID (you can use device_info_plus here)
                            final deviceInfo = await DeviceInfoPlugin()
                                .androidInfo; // For Android devices
                            final deviceID = deviceInfo.device;

                            final String deviceId =
                                deviceID; // Replace with actual device ID
                            if (mounted) {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  authProvider.signInLoading;
                                });
                                final email = emailController.text;
                                final password = passwordController.text;
                                authProvider.signIn(
                                    context, email, password, deviceId);
                              } else {
                                throw Fluttertoast.showToast(
                                    fontSize: 18,
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor:
                                        Colors.red.withOpacity(0.7),
                                    msg: 'Fill empty field',
                                    gravity: ToastGravity.BOTTOM,
                                    textColor: Colors.white);
                              }
                            }
                          },
                          text: 'Sign In',
                          backgroundColor: AppColors.black,
                        ),
                  const VerticalSpacing(30),

                  ///divider
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Divider(
                        color: AppColors.grey.withOpacity(0.2),
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      Container(
                        color: AppColors.white,
                        child: const Text(
                          'OR',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'SFPRODISPLAYREGULAR',
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///google and apply login
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///google
                        Container(
                          height: 55,
                          width: 155,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColors.white,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/google.png",
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                        ),

                        ///apple
                        Container(
                          height: 55,
                          width: 155,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColors.white,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/apple.png",
                                  fit: BoxFit.cover,
                                  width: 24,
                                  height: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///for new users
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: context.textTheme.bodySmall?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.landingSubtextColor),
                      ),
                      AppTextButton(
                        onPressed: () async {
                          context.pop();
                          context.push(const SignUpScreen());
                        },
                        text: 'Sign Up',
                      )
                    ],
                  ),
                  const VerticalSpacing(100),
                ],
              ),
            ),
          ),
        ),
      ),
    ).onTap(context.unfocus);
  }
}
