import 'package:flutter_test/flutter_test.dart';

import 'package:harvest_hub/main.dart';

void main() {
  testWidgets('Harvest Hub app starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HarvestHubApp());

    // Verify that our app title is displayed
    expect(find.text('Harvest Hub'), findsOneWidget);
  });
}
