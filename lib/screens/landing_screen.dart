import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:smartpay/core/extension/build_context_extensions.dart';
import 'package:smartpay/core/extension/widget_extensions.dart';
import 'package:smartpay/screens/signup_screen.dart';
import 'package:smartpay/widgets/app_text_button.dart';

import '../core/constant/assets.dart';
import '../core/constant/colors.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/spacing.dart';

class LandingScreen extends StatefulWidget {
  static String id = 'landing_page';
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  final boardingPages = [
    BoardingPageModel(
      title: 'Finance app the safest\n and most trusted',
      description:
          'Your finance work starts here. we are here to help you track and deal with speeding up your transactions',
      image: Assets.assetsImagesHtu1,
    ),
    BoardingPageModel(
      title: 'The fastest transaction process only here',
      description:
          'Get easy to pay all your bills with just a few steps. Paying your bills becomes fast and efficient.',
      image: Assets.assetsImagesHtu3,
    ),
  ];

  final ValueNotifier<int> _currentPageNotifier = ValueNotifier(0);
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _currentPageNotifier.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 40, right: 40),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppTextButton(
                      onPressed: () {
                        // Navigator.pushNamed(context, SignUpScreen.id);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      },
                      text: 'Skip',
                    ),
                  ],
                ),
                const VerticalSpacing(50),
                PageView.builder(
                  controller: _pageController,
                  itemCount: boardingPages.length,
                  onPageChanged: (index) {
                    _currentPageNotifier.value = index;
                  },
                  itemBuilder: (_, index) {
                    return Column(
                      children: [
                        Image.asset(
                          boardingPages[index].image,
                        ).expand(),
                        const VerticalSpacing(10),
                        Text(
                          boardingPages[index].title,
                          style: context.textTheme.bodyLarge?.copyWith(
                              color: AppColors.black,
                              fontStyle: FontStyle.normal,
                            fontFamily: 'SFPRODISPLAYBOLD',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const VerticalSpacing(10),
                        Text(
                          boardingPages[index].description,
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.landingSubtextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'SFPRODISPLAYREGULAR',),
                        ),
                      ],
                    );
                  },
                ).expand(3),
                const VerticalSpacing(20),
                ValueListenableBuilder(
                  valueListenable: _currentPageNotifier,
                  builder: (context, currentPage, _) {
                    return Column(
                      children: [
                        const VerticalSpacing(20),
                        DotsIndicator(
                          dotsCount: boardingPages.length,
                          position: currentPage,
                          decorator: DotsDecorator(
                            activeColor: AppColors.black,
                            activeSize: const Size(30, 5),
                            activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        const VerticalSpacing(20),

                        ///get started button
                        AppElevatedButton.large(
                          onPressed: () => currentPage < 1
                              ? _pageController.animateToPage(
                                  boardingPages.length - 1,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOut,
                                )
                              : context.push(const SignUpScreen()),
                          text: 'Get Started',
                          textColor: AppColors.white,
                          backgroundColor: AppColors.black,
                        )
                      ],
                    );
                  },
                ),
                const VerticalSpacing(50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BoardingPageModel {
  final String title;
  final String description;
  final String image;

  BoardingPageModel({
    required this.title,
    required this.description,
    required this.image,
  });
}
