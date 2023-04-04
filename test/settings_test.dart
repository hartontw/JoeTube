import 'package:flutter_test/flutter_test.dart';
import 'package:joetube/services/settings.dart';

Future<void> main() async {
  DefaultSettings settings = DefaultSettings();

  test('getters', () {
    expect(settings.getLanguage(), isNotNull);
    expect(settings.getMaxSongHistory(), isNotNull);
    expect(() => settings.getYoutubeApiUrl(), throwsException);
    expect(settings.getYoutubeApiMaxPing(), isNotNull);
  });

  test('setters', () async {
    await settings.setLanguage('es');
    expect(settings.getLanguage(), 'es');

    await settings.setMaxSongHistory(50);
    expect(settings.getMaxSongHistory(), 50);

    await settings.setYoutubeApiUrl('https://api.example.com');
    expect(settings.getYoutubeApiUrl(), 'https://api.example.com');

    await settings.setYoutubeApiMaxPing(100);
    expect(settings.getYoutubeApiMaxPing(), 100);
  });

  test('nulls', () async {
    await settings.setLanguage(null);
    expect(settings.getLanguage(), isNotNull);

    await settings.setMaxSongHistory(null);
    expect(settings.getMaxSongHistory(), isNotNull);

    await settings.setYoutubeApiUrl(null);
    expect(() => settings.getYoutubeApiUrl(), throwsException);

    await settings.setYoutubeApiMaxPing(null);
    expect(settings.getYoutubeApiMaxPing(), isNotNull);
  });
}
