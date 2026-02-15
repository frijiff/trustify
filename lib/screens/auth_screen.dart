import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/color.dart';
import '../controllers/user_controller.dart';
import '../services/appwrite_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final appwrite = AppwriteService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;
  bool showPassword = false;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  Future<void> performLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('error'.tr, 'fill_all'.tr,
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() => isLoading = true);
    try {
      await appwrite.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      await Get.find<UserController>().loadUser();
      Get.offNamed('/home');
      Get.snackbar('success'.tr, 'logged_in'.tr,
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('login_failed'.tr, e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> performSignup() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        nameController.text.isEmpty) {
      Get.snackbar('error'.tr, 'fill_all'.tr,
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('error'.tr, 'passwords_not_match'.tr,
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (passwordController.text.length < 8) {
      Get.snackbar('error'.tr, 'password_length'.tr,
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() => isLoading = true);
    try {
      await appwrite.signup(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
      );

      Get.snackbar('success'.tr, 'account_created'.tr,
          backgroundColor: Colors.green, colorText: Colors.white);
      tabController.animateTo(0);
    } catch (e) {
      Get.snackbar('signup_failed'.tr, e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Elegant Background with minimalist shapes
          Positioned(
            top: -100,
            right: -100,
            child: _buildCircle(400, AppColors.primaryGreen.withOpacity(0.05)),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _buildCircle(300, AppColors.accentOrange.withOpacity(0.03)),
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // Appwrite Ping Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => client.ping(),
                            icon: const Icon(Icons.bolt, size: 16),
                            label: const Text('Ping', style: TextStyle(fontSize: 12)),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Logo and App Name
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Iconsax.verify_copy,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              'trustify'.tr,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        // Dynamic Welcome Text
                        Text(
                          isLogin ? 'welcome_back'.tr : 'create_account'.tr,
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isLogin 
                            ? 'sign_in_continue'.tr 
                            : 'join_community'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 50),
                        
                        // Tab selection (Implicit)
                        Row(
                          children: [
                            _buildTabTrigger('login'.tr, index: 0),
                            const SizedBox(width: 30),
                            _buildTabTrigger('signup'.tr, index: 1),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Input Fields Container
                        Expanded(
                          child: Column(
                            children: [
                              if (!isLogin) ...[
                                _buildTextField(
                                  controller: nameController,
                                  label: 'full_name'.tr,
                                  icon: Iconsax.user_copy,
                                  hint: 'enter_name'.tr,
                                ),
                                const SizedBox(height: 20),
                              ],
                              _buildTextField(
                                controller: emailController,
                                label: 'email_address'.tr,
                                icon: Iconsax.direct_copy,
                                keyboardType: TextInputType.emailAddress,
                                hint: 'enter_email'.tr,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: passwordController,
                                label: 'password'.tr,
                                icon: Iconsax.lock_copy,
                                isPassword: true,
                                hint: 'enter_password'.tr,
                              ),
                              if (!isLogin) ...[
                                const SizedBox(height: 20),
                                _buildTextField(
                                  controller: confirmPasswordController,
                                  label: 'confirm_password'.tr,
                                  icon: Iconsax.lock_1_copy,
                                  isPassword: true,
                                  hint: 'enter_confirm_password'.tr,
                                ),
                              ],
                              if (isLogin)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'forgot_password'.tr,
                                      style: TextStyle(
                                        color: AppColors.primaryGreen,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 40),
                              
                              // Action Button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: isLoading 
                                    ? null 
                                    : (isLogin ? performLogin : performSignup),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        isLogin ? 'sign_in'.tr : 'create_account'.tr,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildTabTrigger(String label, {required int index}) {
    final active = (isLogin && index == 0) || (!isLogin && index == 1);
    return GestureDetector(
      onTap: () {
        setState(() {
          isLogin = index == 0;
          tabController.animateTo(index);
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              color: active ? Colors.black87 : Colors.grey[400],
            ),
          ),
          if (active)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 20,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword && !showPassword,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      showPassword ? Iconsax.eye_copy : Iconsax.eye_slash_copy,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    onPressed: () => setState(() => showPassword = !showPassword),
                  )
                : null,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.primaryGreen.withOpacity(0.5),
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.all(18),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    tabController.dispose();
    super.dispose();
  }
}
