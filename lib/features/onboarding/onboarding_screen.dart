import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../location/location_screen.dart';
import '../../models/onboarding.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  // Create a list of onboarding page models
  final List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      title: "Sync with Nature’s Rhythm",
      subtitle:
      "Experience a peaceful relaxation that’s in rhythm with the natural world. Sleep smarter, wake up better.",
      image: 'assets/onboarding1.jpg',
    ),
    OnboardingPageModel(
      title: "Effortless & Automatic",
      subtitle:
      "No need to set alarms manually. Enjoy relaxation that adapts to your location and lifestyle.",
      image: 'assets/onboarding2.jpg',
    ),
    OnboardingPageModel(
      title: "Relax & Unwind",
      subtitle: "Enjoy the calm that encourages you to pursue your dreams.",
      image: 'assets/onboarding3.jpg',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() {
                onLastPage = index == pages.length - 1;
              });
            },
            itemBuilder: (_, index) {
              final page = pages[index];
              return OnboardingPage(
                title: page.title,
                subtitle: page.subtitle,
                image: page.image,
              );
            },
          ),

          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              child: const Text("Skip", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LocationScreen()));
              },
            ),
          ),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: pages.length,
                  effect: const WormEffect(dotColor: Colors.grey),
                ),
                ElevatedButton(
                  child: Text(onLastPage ? "Done" : "Next"),
                  onPressed: () {
                    if (onLastPage) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LocationScreen(),
                        ),
                      );
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title, subtitle, image;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 300),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
