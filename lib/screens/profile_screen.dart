import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../core/controller/auth_controller.dart';
import '../core/controller/theme_controller.dart';
import '../core/router/app_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;
    final authController = AuthController.to;

    return Obx(() {
      final isDark = themeController.isDarkMode;
      final userData = authController.userData;
      final userName = userData['name'] ?? "User";
      final userEmail = userData['email'] ?? authController.user?.email ?? "";
      final profilePic = userData['profilePic'] ?? "";

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
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 55.r,
                          backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                          child: CircleAvatar(
                            radius: 50.r,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: profilePic.isNotEmpty
                                ? NetworkImage(profilePic)
                                : NetworkImage(
                                    "https://ui-avatars.com/api/?name=$userName&background=1E3A8A&color=fff&size=256",
                                  ) as ImageProvider,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4.w,
                          child: GestureDetector(
                            onTap: () => authController.uploadProfileImage(),
                            child: Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: const BoxDecoration(
                                color: Color(0xFF1E3A8A),
                                shape: BoxShape.circle,
                              ),
                              child: authController.isLoading.value
                                  ? SizedBox(
                                      width: 16.sp,
                                      height: 16.sp,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                            ),
                          ),
                        ),
                      ],
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
                      userEmail,
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
                icon: Icons.person_outline,
                title: "Personal Information",
                onTap: () {},
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

              sectionHeader("Preferences", isDark),
              SizedBox(height: 12.h),
              settingItem(
                isDark: isDark,
                icon: Icons.notifications_none,
                title: "Notifications",
                trailing: Switch(
                  value: true,
                  onChanged: (v) {},
                  activeColor: const Color(0xFF1E3A8A),
                ),
                onTap: () {},
              ),
              settingItem(
                isDark: isDark,
                icon: Icons.language_outlined,
                title: "Language",
                subtitle: "English (US)",
                onTap: () {},
              ),
              settingItem(
                isDark: isDark,
                icon: Icons.dark_mode_outlined,
                title: "Dark Mode",
                trailing: Switch(
                  value: themeController.isDarkMode,
                  onChanged: (v) => themeController.toggleTheme(),
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
