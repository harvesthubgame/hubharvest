import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../widgets/game_button.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Feed the Animals',
      'description':
          'Drag the correct feed to the hungry animals. Cow eats Hay, Sheep eats Grain, Goat eats Vitamins.',
      'image': 'assets/images/hay.png', // Placeholder or use composition
    },
    {
      'title': 'Shoo the Pests',
      'description':
          'Tap on rats and crows before they steal the feed! You get bonus coins for stopping them.',
      'image': 'assets/images/rat.png',
    },
    {
      'title': 'Collect Produce',
      'description':
          'After 3 feedings, animals start glowing. Tap them to collect produce and earn big rewards!',
      'image': 'assets/images/glowing_cow.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HarvestHubTheme.skyBlue,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      slide['title']!,
                      style: HarvestHubTheme.themeData.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      height: 200,
                      width: 300,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.asset(
                        slide['image']!,
                        height: 150,
                        fit: BoxFit.contain,
                        errorBuilder: (c, o, s) =>
                            const Icon(Icons.image, size: 80),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      slide['description']!,
                      style: HarvestHubTheme.themeData.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),

          // Navigation Arrows and Dots
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Previous Arrow
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 28,
                    color: _currentPage > 0
                        ? HarvestHubTheme.darkGrey
                        : HarvestHubTheme.lightGrey,
                  ),
                  onPressed: _currentPage > 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
                const SizedBox(width: 16),
                // Navigation Dots
                ...List.generate(_slides.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? HarvestHubTheme.growthGreen
                          : HarvestHubTheme.lightGrey,
                    ),
                  );
                }),
                const SizedBox(width: 16),
                // Next Arrow
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 28,
                    color: _currentPage < _slides.length - 1
                        ? HarvestHubTheme.darkGrey
                        : HarvestHubTheme.lightGrey,
                  ),
                  onPressed: _currentPage < _slides.length - 1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
              ],
            ),
          ),

          // "Got It" Button on last slide
          if (_currentPage == _slides.length - 1)
            Positioned(
              bottom: 80,
              right: 40,
              child: GameButton(
                label: 'Got It!',
                width: 150,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),

          // Back Button
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 32,
                color: HarvestHubTheme.darkGrey,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
