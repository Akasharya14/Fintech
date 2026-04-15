import 'package:fintech/core/models/dashboard_model.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class DashboardController extends GetxController {
  static DashboardController get to => Get.find();

  final Rxn<DashboardData> _dashboardData = Rxn<DashboardData>();
  DashboardData? get dashboardData => _dashboardData.value;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth user data changes
    ever(AuthController.to.userData, (Map<String, dynamic> data) {
      if (data.isNotEmpty) {
        _mapUserDataToDashboard(data);
      }
    });
    
    // Initial mapping if data already exists
    if (AuthController.to.userData.isNotEmpty) {
      _mapUserDataToDashboard(AuthController.to.userData);
    } else {
      fetchDashboardData();
    }
  }

  void _mapUserDataToDashboard(Map<String, dynamic> data) {
    _dashboardData.value = DashboardData(
      balance: (data['balance'] ?? 0.0).toDouble(),
      income: (data['income'] ?? 0.0).toDouble(),
      expense: (data['expense'] ?? 0.0).toDouble(),
      goldGrams: (data['goldGrams'] ?? 0.0).toDouble(),
      goldValue: (data['goldValue'] ?? 0.0).toDouble(),
      referralCode: data['referralCode'] ?? "N/A",
      // These could also come from Firestore if you want them dynamic
      quickActions: [
        QuickAction(title: "Deposit", icon: "add_circle_outline", route: "/deposit"),
        QuickAction(title: "Portfolio", icon: "pie_chart_outline", route: "/portfolio"),
        QuickAction(title: "Token", icon: "token", route: "/token"),
      ],
      offers: [
        SpecialOffer(
          title: "Get 5% Reward Bonus",
          subtitle: "Invite your friends and earn extra rewards instantly.",
          color1: "0xFF111827",
          color2: "0xFF374151",
        ),
        SpecialOffer(
          title: "New Gold Scheme",
          subtitle: "Invest in digital gold with just ₹10 and save more.",
          color1: "0xFFB45309",
          color2: "0xFFF59E0B",
        ),
      ],
      games: [
        Game(title: "Quiz Master", subtitle: "Earn up to ₹500", reward: "₹500"),
        Game(title: "Spin & Win", subtitle: "Daily lucky rewards", reward: "Lucky"),
        Game(title: "Referral Race", subtitle: "Win mega prizes", reward: "Mega"),
      ],
      youtubeContent: [
        EducationalContent(
          title: "How Digital Gold Works",
          subtitle: "Watch and understand gold investment basics.",
          url: "https://youtu.be/Altbqzw5JaU?si=BZPynLA-YZ8axJvw",
        ),
      ],
      blogs: [
        Blog(
          title: "Smart Saving Tips",
          subtitle: "Learn better money habits with simple steps.",
          url: "https://bettermoneyhabits.bankofamerica.com/en/saving-budgeting/ways-to-save-money",
        ),
        Blog(
          title: "Why Gold Investment Matters",
          subtitle: "Understand the benefits of digital gold saving.",
          url: "https://medium.com/",
        ),
      ],
    );
  }

  Future<void> fetchDashboardData() async {
    if (AuthController.to.user != null) {
      isLoading.value = true;
      await AuthController.to.getUserData(AuthController.to.user!.uid);
      isLoading.value = false;
    }
  }
}
