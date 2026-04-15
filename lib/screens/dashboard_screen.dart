import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/controller/theme_controller.dart';
import '../core/controller/dashboard_controller.dart';
import '../core/controller/auth_controller.dart';
import '../core/router/app_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _showUpdateDialog({
    required BuildContext context,
    required String title,
    required String field,
    required double currentValue,
    bool isGold = false,
  }) {
    final controller = TextEditingController(text: currentValue.toString());
    final isDark = ThemeController.to.isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F1F1F) : Colors.white,
        title: Text(title, style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: "Enter amount",
            hintStyle: TextStyle(color: Colors.grey),
            suffixText: isGold ? "grams" : "₹",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              double? newValue = double.tryParse(controller.text);
              if (newValue != null) {
                if (isGold) {
                  // Assuming gold price is ₹6000 per gram for calculation
                  AuthController.to.updateUserData({
                    'goldGrams': newValue,
                    'goldValue': newValue * 6000,
                  });
                } else {
                  AuthController.to.updateUserData({
                    field: newValue,
                  });
                }
                Navigator.pop(context);
                Get.snackbar("Success", "$title updated successfully");
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;
    final dashboardController = DashboardController.to;

    return Obx(() {
      final isDark = themeController.isDarkMode;
      final isLoading = dashboardController.isLoading.value;
      final data = dashboardController.dashboardData;

      if (isLoading || data == null) {
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF7F8FC),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF7F8FC),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF7F8FC),
          elevation: 0,
          title: Text(
            "FinTech",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () => context.pushNamed(AppRouteNames.profile),
              child: Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: CircleAvatar(
                  backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                  child: Icon(
                    Icons.person_outline,
                    color: isDark ? Colors.white : Colors.black,
                    size: 22.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => dashboardController.fetchDashboardData(),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Account Balance Card (Clickable to Update)
                GestureDetector(
                  onTap: () => _showUpdateDialog(
                    context: context,
                    title: "Update Balance",
                    field: "balance",
                    currentValue: data.balance,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1E3A8A),
                          Color(0xFF2563EB),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Account Balance",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white70,
                              ),
                            ),
                            Icon(Icons.edit, color: Colors.white54, size: 16.sp),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "₹ ${data.balance.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            balanceInfo("Income", "₹ ${data.income}"),
                            balanceInfo("Expense", "₹ ${data.expense}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                /// Gold Balance Card (Clickable to Update)
                GestureDetector(
                  onTap: () => _showUpdateDialog(
                    context: context,
                    title: "Update Gold Grams",
                    field: "goldGrams",
                    currentValue: data.goldGrams,
                    isGold: true,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[900] : Colors.white,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 55.w,
                          height: 55.h,
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Icon(
                            Icons.workspace_premium,
                            color: Colors.orange,
                            size: 28.sp,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Gold Balance",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isDark ? Colors.grey[400] : Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "${data.goldGrams.toStringAsFixed(3)} Grams",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "₹ ${data.goldValue.toStringAsFixed(0)}",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                            ),
                            Icon(Icons.edit, color: Colors.grey, size: 14.sp),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 22.h),

                /// Quick Actions
                Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    quickActionCard(
                      Icons.add_circle_outline, 
                      "Deposit", 
                      isDark,
                      onTap: () => _showUpdateDialog(
                        context: context, 
                        title: "Add Deposit", 
                        field: "balance", 
                        currentValue: data.balance,
                      ),
                    ),
                    quickActionCard(
                      Icons.pie_chart_outline, 
                      "Income", 
                      isDark,
                      onTap: () => _showUpdateDialog(
                        context: context, 
                        title: "Update Income", 
                        field: "income", 
                        currentValue: data.income,
                      ),
                    ),
                    quickActionCard(
                      Icons.account_balance_wallet, 
                      "Expense", 
                      isDark,
                      onTap: () => _showUpdateDialog(
                        context: context, 
                        title: "Update Expense", 
                        field: "expense", 
                        currentValue: data.expense,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 22.h),

                /// Ads / Banner Section
                Text(
                  "Special Offers",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: data.offers.map((offer) {
                      return Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: adBanner(
                          offer.title,
                          offer.subtitle,
                          Color(int.parse(offer.color1)),
                          Color(int.parse(offer.color2)),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 22.h),

                /// Games Section
                Text(
                  "Play & Earn",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: data.games.map((game) {
                      return Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: gameCard(game.title, game.subtitle, isDark),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 22.h),

                /// Referral Section
                Text(
                  "Referral",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : Colors.white,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Invite & Earn",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Share your referral code and earn money.",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDark ? Colors.grey[400] : Colors.grey,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black26 : const Color(0xFFF7F8FC),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.referralCode,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: data.referralCode));
                                Get.snackbar(
                                  "Copied", 
                                  "Referral code copied to clipboard",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green.withOpacity(0.8),
                                  colorText: Colors.white,
                                );
                              },
                              child: Icon(
                                Icons.copy,
                                size: 20.sp,
                                color: isDark ? Colors.grey[400] : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 22.h),

                /// YouTube Section
                Text(
                  "Educational Content",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                ...data.youtubeContent.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: youtubeCard(item.title, item.subtitle, item.url, isDark),
                )),

                SizedBox(height: 22.h),

                /// Blog Section
                Text(
                  "Recent Blogs",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                ...data.blogs.map((blog) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: blogCard(blog.title, blog.subtitle, blog.url, isDark),
                )),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget balanceInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget quickActionCard(IconData icon, String title, bool isDark, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: 105.w,
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28.sp,
              color: const Color(0xFF2563EB),
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget adBanner(String title, String subtitle, Color color1, Color color2) {
    return Container(
      width: 300.w,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            Icons.campaign,
            color: Colors.white,
            size: 35.sp,
          ),
        ],
      ),
    );
  }

  Widget gameCard(String title, String subtitle, bool isDark) {
    return Container(
      width: 160.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF1E3A8A).withOpacity(0.1),
            child: Icon(
              Icons.sports_esports,
              color: const Color(0xFF2563EB),
              size: 22.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? Colors.grey[400] : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget youtubeCard(String title, String subtitle, String url, bool isDark) {
    return InkWell(
      onTap: () async {
        try {
          final Uri uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        } catch (e) {
          Get.snackbar("Error", "Could not launch video");
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.play_circle_fill,
                color: Colors.red,
                size: 35.sp,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget blogCard(String title, String subtitle, String url, bool isDark) {
    return InkWell(
      onTap: () async {
        try {
          final Uri uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        } catch (e) {
          Get.snackbar("Error", "Could not open blog");
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.article_outlined,
                color: Colors.blue,
                size: 35.sp,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
