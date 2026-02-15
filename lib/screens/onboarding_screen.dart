import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/color.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Welcome to Trustify',
      'description': 'A community-driven app for sharing and discovering reviews of local and online shops.',
      'icon': '🏪',
    },
    {
      'title': 'Share Your Experience',
      'description': 'Submit reviews with links, photos, ratings, and text. Help others avoid scams.',
      'icon': '📝',
    },
    {
      'title': 'Discover Reviews',
      'description': 'Search reviews by business link (Instagram, Facebook, etc.) to see community feedback.',
      'icon': '🔍',
    },
    {
      'title': 'Earn Coins',
      'description': 'Each search costs 2 coins. Watch rewarded ads to earn 5 coins and unlock features.',
      'icon': '🪙',
    },
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    Get.offNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return _buildPage(_onboardingData[index]);
            },
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _currentPage > 0
                    ? TextButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          'Back',
                          style: TextStyle(color: AppColors.primaryGreen),
                        ),
                      )
                    : SizedBox(),
                Row(
                  children: List.generate(
                    _onboardingData.length,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? AppColors.primaryGreen
                            : AppColors.mutedGray,
                      ),
                    ),
                  ),
                ),
                _currentPage == _onboardingData.length - 1
                    ? ElevatedButton(
                        onPressed: _completeOnboarding,
                        child: Text('Get Started'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(color: AppColors.primaryGreen),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(Map<String, String> data) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data['icon']!,
            style: TextStyle(fontSize: 80),
          ),
          SizedBox(height: 40),
          Text(
            data['title']!,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            data['description']!,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
