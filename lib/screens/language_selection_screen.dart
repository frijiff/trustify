import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/color.dart';

class LanguageSelectionScreen extends StatelessWidget {
  void _selectLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    Get.updateLocale(Locale(languageCode));
    Get.offNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('Select Language'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose your language',
              style: TextStyle(fontSize: 24, color: AppColors.textDark),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _selectLanguage('en'),
              child: Text('English'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentOrange,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectLanguage('fr'),
              child: Text('Français'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentOrange,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectLanguage('ar'),
              child: Text('العربية'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentOrange,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
