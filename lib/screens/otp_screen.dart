import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:smartpay/core/extension/build_context_extensions.dart';

import '../core/constant/colors.dart';
import '../provider/auth_provider.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/spacing.dart';

class OtpScreen extends StatefulWidget {
  static String id = 'otp';
  const OtpScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final OtpFieldController otpController = OtpFieldController();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userEmail = authProvider.userEmail;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 23, right: 23),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///back button
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
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
                const VerticalSpacing(50),

                ///welcome message
                Text(
                  "Verify it's you",
                  textAlign: TextAlign.justify,
                  style: context.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'SFPRODISPLAYREGULAR',
                      fontSize: 24,
                      color: AppColors.black),
                ),
                const VerticalSpacing(10),

                ///otp promoting message
                Text(
                  'We sent a code to {****@mail.com}. Enter it here to verify your identity',
                  textAlign: TextAlign.justify,
                  style: context.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'SFPRODISPLAYMEDIUM',
                      color: AppColors.landingSubtextColor),
                ),
                const VerticalSpacing(50),

                /// otp field
                OTPTextField(
                  // obscureText: true,
                  controller: otpController,
                  length: 5,
                  width: context.width * 0.8,
                  fieldWidth: 50.w,
                  style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.black,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'SFPRODISPLAYREGULAR',
                      fontWeight: FontWeight.w600),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  outlineBorderRadius: 12.r,
                  otpFieldStyle: OtpFieldStyle(
                    backgroundColor: AppColors.lightGrey,
                    enabledBorderColor: AppColors.lightGrey,
                    focusBorderColor: AppColors.yellow,
                  ),
                  onCompleted: (pin) {
                    if (mounted) {
                      setState(() {
                        authProvider.signUpLoading;
                        final otp = pin;
                        String email = userEmail!;
                        authProvider.sendOtp(
                          context,
                          email,
                          otp,
                        );
                      });
                    }
                  },
                ),
                const VerticalSpacing(20),

                ///resending of otp
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Resend Code 30 sec',
                      style: context.textTheme.bodySmall?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'SFPRODISPLAYBOLD',
                        color: AppColors.landingSubtextColor,
                      ),
                    ),
                  ],
                ),
                const VerticalSpacing(100),

                ///verify button
                authProvider.signUpLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.black),
                        ),
                      )
                    : AppElevatedButton.large(
                        onPressed: () async {
                          if (mounted) {
                            setState(() {
                              authProvider.signUpLoading;
                              final otp = otpController.toString();
                              String email = 'zachtech56@gmail.com';
                              authProvider.sendOtp(
                                context,
                                email,
                                otp,
                              );
                            });
                          }
                        },
                        text: 'Confirm',
                        backgroundColor: AppColors.black,
                      ),
                const VerticalSpacing(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
