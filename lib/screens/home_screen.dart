
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpay/core/extension/build_context_extensions.dart';

import '../core/constant/colors.dart';
import '../provider/auth_provider.dart';
import '../provider/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<int> _characterCount;
  late SecretProvider _secretProvider;
  @override
  void initState() {
    super.initState();
    _secretProvider = Provider.of<SecretProvider>(context, listen: false);
    final authToken = Provider.of<AuthProvider>(context, listen: false).token;
    _secretProvider.setToken(authToken!);
    _secretProvider.fetchSecret(authToken);
    final messageLength = _secretProvider.secretMessage?.length ?? 0;
    final animationDuration = Duration(milliseconds: messageLength * 100); // Adjust multiplier as needed

    _controller = AnimationController(
      vsync: this,
      duration: animationDuration,
    );

    _characterCount = IntTween(begin: 0, end: messageLength).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Dashboard',
          style: context.textTheme.bodySmall?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.black),
        ),
        leading: Container(),
      ),
      body:
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 23, right: 23),
        child: Consumer<SecretProvider>(
          builder: (context, secretProvider, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your daily qoutes',
                      style: context.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'SFPRODISPLAYREGULAR',
                          fontSize: 18,
                          color: AppColors.black),
                    ),
                  ],
                ),

                Icon(Icons.comment_bank_outlined),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.offWhite),
                    color: AppColors.black.withOpacity(0.3),boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5), // Shadow color
                      spreadRadius: 5, // Spread radius
                      blurRadius: 7, // Blur radius
                      offset: Offset(0, 3), // Offset
                    ),
                  ],
                  ),
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        String animatedText = secretProvider.secretMessage ?? 'Loading...';
                        return Text(
                          animatedText,
                          style: context.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'SFPRODISPLAYREGULAR',
                              fontSize: 18,
                              color: AppColors.black),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
