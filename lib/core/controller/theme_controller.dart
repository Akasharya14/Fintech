import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final RxBool _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  late SharedPreferences _prefs;

  Future<ThemeController> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode.value = _prefs.getBool('isDarkMode') ?? false;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    return this;
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _prefs.setBool('isDarkMode', _isDarkMode.value);
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
