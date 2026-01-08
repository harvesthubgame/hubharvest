import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Storage
  await StorageService().init();
  
  // Lock orientation to landscape for better gameplay
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // Set fullscreen mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  runApp(const HarvestHubApp());
}

class HarvestHubApp extends StatelessWidget {
  const HarvestHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harvest Hub',
      debugShowCheckedModeBanner: false,
      theme: HarvestHubTheme.themeData,
      initialRoute: GameRoutes.splash,
      routes: GameRoutes.routes,
    );
  }
}
