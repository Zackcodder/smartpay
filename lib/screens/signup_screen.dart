import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpay/core/extension/build_context_extensions.dart';
import 'package:smartpay/core/extension/widget_extensions.dart';

import '../core/constant/colors.dart';
import '../provider/auth_provider.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_text_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/spacing.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  static String id = 'signup';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _emailError;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.only(left: 23, right: 23),
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
                      child: const Center(child: Icon(Icons.arrow_back_ios, size: 15,),),
                    ),
                  ),
                  const VerticalSpacing(50),

                  ///welcome message
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Create a Smartpay\naccount',
                        textAlign: TextAlign.justify,
                        style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'SFPRODISPLAYBOLD',
                            fontSize: 24,
                            color: AppColors.black),
                      ),
                    ],
                  ),
                  const VerticalSpacing(50),

                  ///email address
                  AppTextField(
                    onTap: () {
                      // Clear error message when the text field is tapped
                      setState(() {
                        _emailError = null;
                      });
                    },
                    onChanged: (value) {
                      // Perform validation and update error message accordingly
                      setState(() {
                        _emailError = null;
                      });
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    hintText: ' Email',
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

                  ///signup button
                  authProvider.signUpLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          ),
                        )
                      : AppElevatedButton.large(
                          onPressed: () async {
                            if(mounted){
                              if(_formKey.currentState!.validate()){
                                final email = emailController.text;
                                authProvider.signUp(context, email);
                                authProvider.signUpLoading == false;
                                setState(() {
                                });
                              }else{
                                setState(() {
                                  authProvider.signUpLoading == false;
                                });
                              }
                            }
                          },
                          text: 'Sign Up',
                          backgroundColor: AppColors.black.withOpacity(0.2),
                        ),
                  const VerticalSpacing(50),

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
                    margin: const EdgeInsets.only(top: 30, bottom: 80),
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

                  ///already has an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'SFPRODISPLAYBOLD',
                            color: AppColors.landingSubtextColor),
                      ),
                      AppTextButton(
                        onPressed: () {
                          context.push(const LoginScreen());
                        },
                        text: 'Sign In',
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).onTap(context.unfocus);
  }
}
