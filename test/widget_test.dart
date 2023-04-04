import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:joetube/main.dart';
import 'package:joetube/services/audio_service.dart';
import 'package:joetube/services/settings.dart';

import 'mocks/youtube_api.dart';

void main() {
  testWidgets('Routes', (WidgetTester tester) async {
    DefaultSettings settings = DefaultSettings();

    AudioService audio = AudioService(settings.getMaxSongHistory());

    MockYouTubeApi youtube = MockYouTubeApi();

    await tester.pumpWidget(
        JoeTube(settings: settings, audio: audio, youtube: youtube));

    expect(Get.currentRoute, '/');
  });
}
