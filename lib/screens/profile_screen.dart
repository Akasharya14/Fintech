import 'package:fintech/core/controller/auth_controller.dart';
import 'package:fintech/core/controller/theme_controller.dart';
import 'package:fintech/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _getInitials(String name) {
    if (name.isEmpty) return "U";
    List<String> parts = name.trim().split(" ");
    String initials = "";
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      initials += parts[0][0].toUpperCase();
    }
    if (parts.length > 1 && parts[parts.length - 1].isNotEmpty) {
      initials += parts[parts.length - 1][0].toUpperCase();
    }
    return initials.isEmpty ? "U" : initials;
  }

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;
    final authController = AuthController.to;

    return Obx(() {
      final isDark = themeController.isDarkMode;
      final userData = authController.userData;
      final userName = userData['name'] ?? "User";
      final userEmail = userData['email'] ?? authController.user?.email ?? "";
      final userPhone = userData['phone'] ?? authController.user?.phoneNumber ?? "No Phone Number";
      final settings = userData['settings'] ?? {};
      final bool notificationsEnabled = settings['notifications'] ?? true;
      final referralCode = userData['referralCode'] ?? "N/A";
      
      String joinedDate = "N/A";
      if (userData['createdAt'] != null) {
        DateTime dt = (userData['createdAt'] as Timestamp).toDate();
        joinedDate = DateFormat('MMMM yyyy').format(dt);
      }

      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF7F8FC),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF7F8FC),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black, size: 20),
            onPressed: () => context.pop(),
          ),
          title: Text(
            "Profile",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),

              /// 1. User Profile Details
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 55.r,
                      backgroundColor: const Color(0xFF1E3A8A),
                      child: Text(
                        _getInitials(userName),
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Joined $joinedDate",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    if (userEmail.isNotEmpty)
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDark ? Colors.grey[400] : Colors.grey.shade600,
                        ),
                      ),
                    SizedBox(height: 2.h),
                    Text(
                      userPhone,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              /// 2. Account Settings & Preferences
              sectionHeader("Account Settings", isDark),
              SizedBox(height: 12.h),
              settingItem(
                isDark: isDark,
                icon: Icons.qr_code_scanner,
                title: "My Referral Code",
                subtitle: referralCode,
                onTap: () {
                  if (referralCode != "N/A") {
                    Clipboard.setData(ClipboardData(text: referralCode));
                    Get.snackbar(
                      "Copied", 
                      "Referral code copied to clipboard",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green.withOpacity(0.7),
                      colorText: Colors.white,
                    );
                  }
                },
              ),
              settingItem(
                isDark: isDark,
                icon: Icons.account_balance_wallet_outlined,
                title: "Payment Methods",
                onTap: () {},
              ),
              settingItem(
                isDark: isDark,
                icon: Icons.security_outlined,
                title: "Security & Password",
                onTap: () {},
              ),

              SizedBox(height: 24.h),

              settingItem(
                isDark: isDark,
                icon: Icons.language_outlined,
                title: "Language",
                subtitle: settings['language'] ?? "English",
                onTap: () {},
              ),
              settingItem(
                isDark: isDark,
                icon: Icons.dark_mode_outlined,
                title: "Dark Mode",
                trailing: Switch(
                  value: themeController.isDarkMode,
                  onChanged: (v) {
                    themeController.toggleTheme();
                    authController.updateUserData({
                      'settings.darkMode': v,
                    });
                  },
                  activeColor: const Color(0xFF1E3A8A),
                ),
                onTap: () => themeController.toggleTheme(),
              ),

              SizedBox(height: 32.h),

              /// 3. Logout Option
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                    foregroundColor: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      side: BorderSide(color: Colors.red.shade100.withOpacity(isDark ? 0.2 : 1)),
                    ),
                  ),
                  onPressed: () => _showLogoutDialog(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 20.sp),
                      SizedBox(width: 10.w),
                      Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      );
    });
  }

  Widget sectionHeader(String title, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.grey[400] : Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget settingItem({
    required bool isDark,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: isDark ? Colors.black26 : const Color(0xFFF7F8FC),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: const Color(0xFF1E3A8A), size: 22.sp),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(fontSize: 12.sp, color: isDark ? Colors.grey[500] : Colors.grey),
              )
            : null,
        trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await AuthController.to.logout();
              if (context.mounted) {
                context.goNamed(AppRouteNames.login);
              }
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
