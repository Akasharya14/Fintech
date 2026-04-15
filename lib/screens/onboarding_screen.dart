import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../core/router/app_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();
  int currentIndex = 0;

  List<Map<String, dynamic>> onboardingData = [
    {
      "icon": Icons.lock_outline,
      "title": "Secure Access",
      "subtitle": "Your account is safe and protected.",
    },
    {
      "icon": Icons.savings_outlined,
      "title": "Smart Savings",
      "subtitle": "Track your money and savings easily.",
    },
    {
      "icon": Icons.workspace_premium_outlined,
      "title": "Gold & Rewards",
      "subtitle": "Manage gold and earn rewards.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.goNamed(AppRouteNames.login),
                child: Text(
                  "Skip",
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: onboardingData.length,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 90.r,
                        backgroundColor: const Color(0xFF1E3A8A).withOpacity(0.1),
                        child: Icon(
                          onboardingData[index]["icon"],
                          size: 70.sp,
                          color: const Color(0xFF1E3A8A),
                        ),
                      ),
                      SizedBox(height: 35.h),
                      Text(
                        onboardingData[index]["title"],
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text(
                          onboardingData[index]["subtitle"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: currentIndex == index ? 22.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? const Color(0xFF1E3A8A)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                onPressed: () {
                  if (currentIndex == onboardingData.length - 1) {
                    context.goNamed(AppRouteNames.login);
                  } else {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Text(
                  currentIndex == onboardingData.length - 1
                      ? "Get Started"
                      : "Next",
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
