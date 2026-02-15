import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/color.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLanguage();
  }

  void _checkLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final language = prefs.getString('language');
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    Future.delayed(Duration(seconds: 3), () {
      if (language == null) {
        Get.offNamed('/language');
      } else {
        Get.updateLocale(Locale(language));
        // Assume auth is required, so go to auth
        Get.offNamed('/auth');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Trustify',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentOrange),
            ),
          ],
        ),
      ),
    );
  }
}
