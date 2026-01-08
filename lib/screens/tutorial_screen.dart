import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../widgets/game_button.dart';
import '../models/tutorial_slide.dart';

class TutorialScreen extends StatefulWidget {
  final List<TutorialSlide>? slides;

  const TutorialScreen({super.key, this.slides});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late List<TutorialSlide> _slides;

  @override
  void initState() {
    super.initState();
    _slides = widget.slides ??
        [
          const TutorialSlide(
            title: 'Feed the Animals',
            description:
                'Drag the correct feed to the hungry animals. Cow eats Hay, Sheep eats Grain, Goat eats Vitamins.',
            imagePath: 'assets/images/hay.png',
          ),
          const TutorialSlide(
            title: 'Shoo the Pests',
            description:
                'Tap on rats and crows before they steal the feed! You get bonus coins for stopping them.',
            imagePath: 'assets/images/rat.png',
          ),
          const TutorialSlide(
            title: 'Collect Produce',
            description:
                'After 3 feedings, animals start glowing. Tap them to collect produce and earn big rewards!',
            imagePath: 'assets/images/glowing_cow.png',
          ),
        ];
  }

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
          // Main Content
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
              return CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60), // Space for back button
                          Text(
                            slide.title,
                            style: HarvestHubTheme.themeData.textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 200,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(20.0),
                            child: Image.asset(
                              slide.imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (c, o, s) => const Icon(
                                  Icons.image,
                                  size: 60,
                                  color: HarvestHubTheme.soilBrown),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            slide.description,
                            style: HarvestHubTheme.themeData.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 120), // Space for nav controls
                        ],
                      ),
                    ),
                  ),
                ],
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
              bottom: 90, // Adjusted to be above nav controls if needed or clearer
              right: 20,
              child: SafeArea(
                child: GameButton(
                  label: 'Got It!',
                  width: 140,
                  height: 50,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),

          // Back Button
          Positioned(
            top: 10,
            left: 10,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 32,
                  color: HarvestHubTheme.darkGrey,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
