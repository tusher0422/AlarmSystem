import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/onboarding.dart';
import '../../features/location/location_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < onboardingPages.length - 1) {
      setState(() {
        _currentPage++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LocationScreen()),
      );
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LocationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final page = onboardingPages[_currentPage];
    final bottomBoxColor = darkTheme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bottomBoxColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top image with curved bottom overlay + gradient blend
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: CurvedBottomClipper(),
                    child: Stack(
                      children: [
                        // Image
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Image.asset(
                            page.image,
                            key: ValueKey(page.image),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        // Gradient overlay at bottom
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  bottomBoxColor.withOpacity(0.8),
                                  bottomBoxColor,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Skip button
                  Positioned(
                    top: 16,
                    right: 20,
                    child: TextButton(
                      onPressed: _skip,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom content
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(20),
                color: bottomBoxColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title & Subtitle
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            page.title,
                            key: ValueKey(page.title),
                            style: darkTheme.textTheme.bodyLarge?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            page.subtitle,
                            key: ValueKey(page.subtitle),
                            style: darkTheme.textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Dots + Next button
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            onboardingPages.length,
                                (dotIndex) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == dotIndex
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: darkTheme.elevatedButtonTheme.style?.copyWith(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            onPressed: _nextPage,
                            child: const Text(
                              'Next',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Curved bottom shape for image
class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
