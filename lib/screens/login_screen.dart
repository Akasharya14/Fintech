import 'package:fintech/core/controller/auth_controller.dart';
import 'package:fintech/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isPhoneLogin = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await AuthController.to.login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      } catch (e) {
        // Error is handled in AuthController
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _handlePhoneLogin() async {
    String phone = phoneController.text.trim();
    if (phone.isEmpty || (phone.length < 10)) {
      Get.snackbar("Error", "Please enter a valid 10-digit phone number");
      return;
    }

    // Automatically add +91 if country code is missing
    if (!phone.startsWith('+')) {
      if (phone.length == 10) {
        phone = '+91$phone';
      } else if (phone.length == 12 && phone.startsWith('91')) {
        phone = '+$phone';
      } else {
         // If it's something else but doesn't have +, try to add +91 or just +
         // For simplicity, if it's 10 digits, add +91.
         phone = '+91$phone';
      }
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await AuthController.to.verifyPhoneNumber(phone);
      if (mounted) {
        context.pushNamed(AppRouteNames.otp);
      }
    } catch (e) {
      // Error handled in AuthController
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70.h),
              Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Login to continue",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 35.h),

              if (!_isPhoneLogin) ...[
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (!_isPhoneLogin && (value == null || value.isEmpty)) {
                      return 'Please enter your email';
                    }
                    if (!_isPhoneLogin && !GetUtils.isEmail(value!)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (!_isPhoneLogin && (value == null || value.isEmpty)) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ] else ...[
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    prefixText: "+91 ",
                    prefixIcon: const Icon(Icons.phone_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],

              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isPhoneLogin = !_isPhoneLogin;
                    });
                  },
                  child: Text(
                    _isPhoneLogin ? "Use Email Login" : "Use Phone Login",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ),

              if (!_isPhoneLogin)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.pushNamed(AppRouteNames.forgotPassword),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ),

              SizedBox(height: 20.h),

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
                  onPressed: _isLoading ? null : (_isPhoneLogin ? _handlePhoneLogin : _handleLogin),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _isPhoneLogin ? "Send OTP" : "Login",
                          style: TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                ),
              ),

              SizedBox(height: 20.h),
              Center(
                child: TextButton(
                  onPressed: () => context.pushNamed(AppRouteNames.register),
                  child: Text(
                    "Don't have an account? Register",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
