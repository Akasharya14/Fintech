import 'package:get/get.dart';
import '../models/dashboard_model.dart';

class DashboardController extends GetxController {
  static DashboardController get to => Get.find();

  final Rxn<DashboardData> _dashboardData = Rxn<DashboardData>();
  DashboardData? get dashboardData => _dashboardData.value;

  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      // Simulate API Call
      await Future.delayed(const Duration(seconds: 2));

      _dashboardData.value = DashboardData(
        balance: 24500.00,
        income: 8500.00,
        expense: 2300.00,
        goldGrams: 0.450,
        goldValue: 2850.0,
        referralCode: "AKASH2026",
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
            url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
          ),
        ],
        blogs: [
          Blog(
            title: "Smart Saving Tips",
            subtitle: "Learn better money habits with simple steps.",
            url: "https://medium.com/",
          ),
          Blog(
            title: "Why Gold Investment Matters",
            subtitle: "Understand the benefits of digital gold saving.",
            url: "https://medium.com/",
          ),
        ],
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch data");
    } finally {
      isLoading.value = false;
    }
  }
}
