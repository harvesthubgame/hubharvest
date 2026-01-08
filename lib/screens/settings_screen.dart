import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../widgets/toggle_switch.dart';
import '../services/storage_service.dart';
import '../game/managers/audio_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _musicOn;
  late bool _sfxOn;

  @override
  void initState() {
    super.initState();
    _musicOn = StorageService().musicOn;
    _sfxOn = StorageService().sfxOn;
  }

  void _toggleMusic(bool value) {
    setState(() => _musicOn = value);
    StorageService().setMusicOn(value);
    if (value) {
      AudioManager().playBgm('menubg.mp3');
    } else {
      AudioManager().stopBgm();
    }
  }

  void _toggleSfx(bool value) {
    setState(() => _sfxOn = value);
    StorageService().setSfxOn(value);
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HarvestHubTheme.cardRadius),
        ),
        child: Container(
          padding: const EdgeInsets.all(HarvestHubTheme.spacingLarge),
          width: 420,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(HarvestHubTheme.cardRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'About Harvest Hub',
                    style: HarvestHubTheme.themeData.textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: HarvestHubTheme.spacingMedium),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: HarvestHubTheme.skyBlue.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 80,
                      height: 80,
                      errorBuilder: (c, o, s) => const Icon(
                        Icons.agriculture,
                        size: 60,
                        color: HarvestHubTheme.growthGreen,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Harvest Hub: Feed & Thrive',
                      style: HarvestHubTheme.themeData.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Version 1.0.0',
                      style: HarvestHubTheme.themeData.textTheme.bodySmall
                          ?.copyWith(color: HarvestHubTheme.darkGrey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: HarvestHubTheme.spacingMedium),
              Text(
                'Welcome to your own little farm! Feed hungry animals by dragging '
                'the right food to them. Cows love hay, sheep prefer grain, and '
                'goats need their vitamins. Keep them happy, collect rewards, '
                'and watch out for pesky pests!\n\n'
                'A fun, family-friendly game for all ages. No violence, just '
                'farming fun!',
                style: HarvestHubTheme.themeData.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: HarvestHubTheme.spacingMedium),
              Text(
                '© 2025 Harvest Hub',
                style: HarvestHubTheme.themeData.textTheme.bodySmall
                    ?.copyWith(color: HarvestHubTheme.lightGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HarvestHubTheme.cardRadius),
        ),
        child: Container(
          padding: const EdgeInsets.all(HarvestHubTheme.spacingLarge),
          width: 420,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(HarvestHubTheme.cardRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Privacy Policy',
                    style: HarvestHubTheme.themeData.textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: HarvestHubTheme.spacingMedium),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPrivacySection(
                      icon: Icons.wifi_off,
                      title: 'Offline Game',
                      content: 'Harvest Hub works completely offline. '
                          'No internet connection is required to play.',
                    ),
                    const SizedBox(height: 12),
                    _buildPrivacySection(
                      icon: Icons.security,
                      title: 'No Data Collection',
                      content: 'We do not collect, store, or share any '
                          'personal information. Your privacy is safe with us.',
                    ),
                    const SizedBox(height: 12),
                    _buildPrivacySection(
                      icon: Icons.save,
                      title: 'Local Storage Only',
                      content: 'Game progress and settings are saved locally '
                          'on your device and never leave it.',
                    ),
                    const SizedBox(height: 12),
                    _buildPrivacySection(
                      icon: Icons.child_care,
                      title: 'Kid-Friendly',
                      content: 'This game contains no ads, no in-app purchases, '
                          'and no third-party tracking.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: HarvestHubTheme.spacingMedium),
              Text(
                'Last updated: January 2025',
                style: HarvestHubTheme.themeData.textTheme.bodySmall
                    ?.copyWith(color: HarvestHubTheme.lightGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacySection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: HarvestHubTheme.growthGreen),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: HarvestHubTheme.themeData.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: HarvestHubTheme.themeData.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HarvestHubTheme.cardRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(HarvestHubTheme.spacingLarge),
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(HarvestHubTheme.cardRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Settings',
                  style: HarvestHubTheme.themeData.textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: HarvestHubTheme.spacingLarge),

            // Music
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      _musicOn
                          ? 'assets/images/speaker.png'
                          : 'assets/images/mute.png',
                      width: 32,
                      height: 32,
                      errorBuilder: (c, o, s) =>
                          Icon(_musicOn ? Icons.music_note : Icons.music_off),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Music',
                      style: HarvestHubTheme.themeData.textTheme.bodyLarge,
                    ),
                  ],
                ),
                ToggleSwitch(value: _musicOn, onChanged: _toggleMusic),
              ],
            ),

            const SizedBox(height: HarvestHubTheme.spacingMedium),

            // SFX
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.volume_up,
                      size: 32,
                      color: HarvestHubTheme.darkGrey,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Sound Effects',
                      style: HarvestHubTheme.themeData.textTheme.bodyLarge,
                    ),
                  ],
                ),
                ToggleSwitch(value: _sfxOn, onChanged: _toggleSfx),
              ],
            ),

            const SizedBox(height: HarvestHubTheme.spacingLarge),
            const Divider(),
            const SizedBox(height: HarvestHubTheme.spacingSmall),

            // About Game
            _buildSettingsButton(
              icon: Icons.info_outline,
              label: 'About the Game',
              onTap: _showAboutDialog,
            ),

            const SizedBox(height: HarvestHubTheme.spacingSmall),

            // Privacy Policy
            _buildSettingsButton(
              icon: Icons.privacy_tip_outlined,
              label: 'Privacy Policy',
              onTap: _showPrivacyDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              Icon(icon, size: 24, color: HarvestHubTheme.darkGrey),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: HarvestHubTheme.themeData.textTheme.bodyLarge,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: HarvestHubTheme.lightGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
