import 'package:country_list_pick/country_list_pick.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smartpay/core/extension/build_context_extensions.dart';
import 'package:smartpay/core/extension/widget_extensions.dart';

import '../core/constant/colors.dart';
import '../provider/auth_provider.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/spacing.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  ///getting phone name
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
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController selectedCountryController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _showCountrySelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CountryListPick(
          appBar: AppBar(
            title: const Text('Select Country'),
          ),
          theme: CountryTheme(
            isShowFlag: true,
            isShowTitle: true,
            isShowCode: true,
            isDownIcon: true,
            showEnglishName: true,
          ),
          initialSelection: 'US',
          onChanged: (CountryCode? code) {
            selectedCountryController.text = code!.code!;
            Navigator.pop(context); // Close bottom sheet after selection
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
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
                    onTap: ()=> Navigator.pop(context),
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.offWhite),
                        color: AppColors.white,
                      ),
                      child: const Center(child: Icon(Icons.arrow_back_ios, size: 15,),),
                    ),
                  ),
                  const VerticalSpacing(20),
                  ///welcome text
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Hey there! tell us a bit \nabout',
                          style:  context.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'SFPRODISPLAYREGULAR',
                              fontSize: 24,
                              color: AppColors.black),
                        ),
                        TextSpan(
                          text: ' yourself',
                          style:  context.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'SFPRODISPLAYREGULAR',
                              fontSize: 24,
                              color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                  const VerticalSpacing(50),
                  ///full name text field
                  AppTextField(
                    controller: fullNameController,
                    hintText: 'Full name',
                    validator:  (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null; // Return null if validation passes
                    },
                  ),
                  const VerticalSpacing(20),
                  ///username
                  AppTextField(
                    controller: userNameController,
                    hintText: 'Username',
                  ),
                  const VerticalSpacing(20),
                  ///email
                  AppTextField(
                    controller: emailController,
                    hintText: 'Email',
                    validator:  (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      // Check for email format using regex
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Invalid email format';
                      }
                      return null; // Return null if validation passes
                    },
                  ),
                  const VerticalSpacing(20),
                  ///selected country
                  AppTextField(
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    controller: selectedCountryController,
                    hintText: 'Selected Country',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      onPressed: () {
                        _showCountrySelectionBottomSheet(context);
                      },
                    ),
                  ),
                  const VerticalSpacing(20),
                  ///password
                  AppTextField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    hintText: 'Password',
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      // Check for password complexity requirements
                      if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$').hasMatch(value)) {
                        return 'Password must contain at least one uppercase \nletter, one lowercase letter, one number, and be \nat least 6 characters long';
                      }
                      return null; // Return null if validation passes
                    },
                  ),
                  const VerticalSpacing(20),

                  /// register button
                  authProvider.signUpLoading == true
                      ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.black),
                    ),
                  )
                      : AppElevatedButton.large(
                    onPressed: () async {
                      /// Get device ID (you can use device_info_plus here)
                      final deviceInfo = await DeviceInfoPlugin()
                          .androidInfo; // For Android devices
                      final deviceID = deviceInfo.device;

                      final String deviceId =deviceID; // Replace with actual device ID
                      if(mounted){
                        if(_formKey.currentState!.validate()){
                          final fullName = fullNameController.text;
                          final userName = userNameController.text;
                          final email = emailController.text;
                          final country = selectedCountryController.text;
                          final password = passwordController.text;
                          authProvider.register(context, fullName, userName, email, country,
                              password,  deviceId);

                          setState(() {
                            authProvider.signUpLoading;
                          });
                        }else{
                          throw Fluttertoast.showToast(
                              fontSize: 18,
                              toastLength: Toast.LENGTH_LONG,
                              backgroundColor: Colors.red.withOpacity(0.7),
                              msg: 'Fill empty field',
                              gravity: ToastGravity.BOTTOM,
                              textColor: Colors.white);
                        }

                      }
                    },
                    text: 'Continue',
                    backgroundColor: AppColors.black,
                  ),
                  const VerticalSpacing(10),
                ],
              ),
            ),
          ),
        ),
      ),
    ).onTap(context.unfocus);
  }
}
