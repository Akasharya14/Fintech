import 'package:fintech/core/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';


class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    // Announcement when screen opens
    await flutterTts.speak("Please enter the six digit verification code sent to your phone.");
  }

  Future<void> _speakDigit(String digit) async {
    if (digit.isNotEmpty) {
      await flutterTts.speak(digit);
    }
  }

  Future<void> _speakOtp() async {
    String currentOtp = _controllers.map((e) => e.text).join();
    if (currentOtp.isEmpty) {
      await flutterTts.speak("Please enter the code first to hear it back.");
      return;
    }
    await flutterTts.speak("The code you entered is ${currentOtp.split('').join(' ')}");
  }

  Future<void> _handleVerify() async {
    String otp = _controllers.map((e) => e.text).join();
    if (otp.length < 6) {
      Get.snackbar("Error", "Please enter the full 6-digit OTP", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthController.to.signInWithOtp(otp);
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
  void dispose() {
    flutterTts.stop();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              "Enter OTP",
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Enter the 6 digit code sent to your phone",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 35.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 45.w,
                  height: 55.h,
                  child: TextFormField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _speakDigit(value); // Speaks the digit typed
                        if (index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        }
                      } else if (value.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            Center(
              child: TextButton.icon(
                onPressed: _speakOtp,
                icon: const Icon(Icons.volume_up, color: Color(0xFF1E3A8A)),
                label: Text(
                  "Listen to entered OTP",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: const Color(0xFF1E3A8A),
                    fontWeight: FontWeight.w600,
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
                onPressed: _isLoading ? null : _handleVerify,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Verify & Continue",
                        style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
