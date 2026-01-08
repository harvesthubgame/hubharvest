import 'package:flutter/material.dart';
import '../config/routes.dart';
import '../config/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // Minimum delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Navigate directly to main menu (privacy notice removed)
    Navigator.of(context).pushReplacementNamed(GameRoutes.mainMenu);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HarvestHubTheme.skyBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              errorBuilder: (c, o, s) => const Icon(Icons.broken_image, size: 100),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: HarvestHubTheme.growthGreen),
          ],
        ),
      ),
    );
  }
}
