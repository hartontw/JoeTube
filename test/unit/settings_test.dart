import 'package:flutter_test/flutter_test.dart';
import 'package:joetube/services/settings.dart';

Future<void> main() async {
  DefaultSettings settings = DefaultSettings();

  test('getters', () {
    expect(settings.getLanguage(), isNotNull);
    expect(settings.getMaxSongHistory(), isNotNull);
    expect(settings.getYoutubeApiSettings(), isA<YoutubeApiSettings>());
    expect(settings.getYoutubeApiSettings().url, isNull);
    expect(settings.getYoutubeApiSettings().maxPing, 50);
  });

  test('setters', () async {
    await settings.setLanguage('es');
    expect(settings.getLanguage(), 'es');

    await settings.setMaxSongHistory(50);
    expect(settings.getMaxSongHistory(), 50);

    await settings.setYoutubeApiSettings(
        YoutubeApiSettings(url: 'https://api.example.com'));
    expect(settings.getYoutubeApiSettings().url, 'https://api.example.com');
    expect(settings.getYoutubeApiSettings().maxPing, 50);
  });

  test('nulls', () async {
    await settings.setLanguage(null);
    expect(settings.getLanguage(), isNotNull);

    await settings.setMaxSongHistory(null);
    expect(settings.getMaxSongHistory(), isNotNull);

    await settings.setYoutubeApiSettings(null);
    expect(settings.getYoutubeApiSettings(), isA<YoutubeApiSettings>());
  });
}
