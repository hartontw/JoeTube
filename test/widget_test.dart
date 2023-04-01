import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:joetube/main.dart';

void main() {
  testWidgets('Routes', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const JoeTube());
    expect(Get.currentRoute, '/');
  });
}
