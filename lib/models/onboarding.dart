class OnboardingPageModel {
  final String title;
  final String subtitle;
  final String image;

  OnboardingPageModel({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

final List<OnboardingPageModel> onboardingPages = [
  OnboardingPageModel(
    title: "Sync with Nature's Rhythm",
    subtitle: "Experience a peaceful transition into the evening with an alarm that aligns with the sunset.Your perfect reminder, always 15 minutes before sundown",
    image: "assets/onboarding1.jpg",
  ),
  OnboardingPageModel(
    title: "Effortless & Automatic",
    subtitle: "No need to set alarms manually. Wakey calculates the sunset time for your location and alerts you on time.",
    image: "assets/onboarding2.jpg",
  ),
  OnboardingPageModel(
    title: "Relax & Unwind",
    subtitle: "hope to take the courage to pursue your dreams.",
    image: "assets/onboarding3.jpg",
  ),
];
