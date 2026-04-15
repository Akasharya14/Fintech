class DashboardData {
  final double balance;
  final double income;
  final double expense;
  final double goldGrams;
  final double goldValue;
  final String referralCode;
  final List<QuickAction> quickActions;
  final List<SpecialOffer> offers;
  final List<Game> games;
  final List<EducationalContent> youtubeContent;
  final List<Blog> blogs;

  DashboardData({
    required this.balance,
    required this.income,
    required this.expense,
    required this.goldGrams,
    required this.goldValue,
    required this.referralCode,
    required this.quickActions,
    required this.offers,
    required this.games,
    required this.youtubeContent,
    required this.blogs,
  });
}

class QuickAction {
  final String title;
  final String icon; // Icon name or path
  final String route;

  QuickAction({required this.title, required this.icon, required this.route});
}

class SpecialOffer {
  final String title;
  final String subtitle;
  final String color1;
  final String color2;

  SpecialOffer({
    required this.title,
    required this.subtitle,
    required this.color1,
    required this.color2,
  });
}

class Game {
  final String title;
  final String subtitle;
  final String reward;

  Game({required this.title, required this.subtitle, required this.reward});
}

class EducationalContent {
  final String title;
  final String subtitle;
  final String url;

  EducationalContent({required this.title, required this.subtitle, required this.url});
}

class Blog {
  final String title;
  final String subtitle;
  final String url;

  Blog({required this.title, required this.subtitle, required this.url});
}
