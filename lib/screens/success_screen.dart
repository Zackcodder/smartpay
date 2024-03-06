import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpay/core/extension/build_context_extensions.dart';
import 'package:smartpay/screens/login.dart';

import '../core/constant/colors.dart';
import '../provider/auth_provider.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/spacing.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.userLastName;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 23, right: 23),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/thumbsup.png'),
            const VerticalSpacing(30),
           Text('Congratulations, $userName',style: context.textTheme.bodySmall?.copyWith(
               fontWeight: FontWeight.w700,
               fontStyle: FontStyle.normal,
               fontFamily: 'SFPRODISPLAYBOLD',
               fontSize: 24,
               color: AppColors.black),),
            const VerticalSpacing(20),
           Text("You've completed the onboarding,\n you can start using",
             textAlign: TextAlign.center,
             style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w400,
                 fontStyle: FontStyle.normal,
                 fontFamily: 'SFPRODISPLAYREGULAR',
              fontSize: 16,
              color: AppColors.landingSubtextColor),),
            const VerticalSpacing(50),
          AppElevatedButton.large(
            onPressed: () async {
            if(mounted){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
            }
            },
            text: 'Get Started',
            backgroundColor: AppColors.black,
            ),
            const VerticalSpacing(10),
          ],
        ),
      ),
    );
  }
}
