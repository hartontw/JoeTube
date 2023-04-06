import 'package:shared_preferences/shared_preferences.dart';

class YoutubeApiSettings {
  final String? url;
  final int? maxPing;

  YoutubeApiSettings({this.url, this.maxPing = 50});
}

abstract class Settings {
  final List<Function(int)> _maxSongHistoryListeners = [];
  final List<Function(YoutubeApiSettings)> _youtubeSettingsListeners = [];

  void addMaxSongHistoryListener(Function(int) event) {
    _maxSongHistoryListeners.add(event);
  }

  void removeMaxSongHistoryListener(Function(int) event) {
    _maxSongHistoryListeners.remove(event);
  }

  void addYoutubeApiUrlListener(Function(YoutubeApiSettings) event) {
    _youtubeSettingsListeners.add(event);
  }

  void removeYoutubeApiUrlListener(Function(YoutubeApiSettings) event) {
    _youtubeSettingsListeners.remove(event);
  }

  void _onMaxSongHistoryChanged() {
    for (var listener in _maxSongHistoryListeners) {
      listener(getMaxSongHistory());
    }
  }

  void _onYoutubeSettingsChanged() {
    for (var listener in _youtubeSettingsListeners) {
      listener(getYoutubeApiSettings());
    }
  }

  String getLanguage();
  Future<void> setLanguage(String? language);

  int getMaxSongHistory();
  Future<void> setMaxSongHistory(int? maxHistory);

  YoutubeApiSettings getYoutubeApiSettings();
  Future<void> setYoutubeApiSettings(YoutubeApiSettings? settings);
}

class DefaultSettings extends Settings {
  static const String _defaultLanguage = 'en';
  static const int _defaultMaxSongHistory = 25;
  static final YoutubeApiSettings _defaultYoutubeApiSettings =
      YoutubeApiSettings();

  String? _language;
  int? _maxSongHistory;
  YoutubeApiSettings? _youtubeApiSettings;

  DefaultSettings() {
    _language = _defaultLanguage;
    _maxSongHistory = _defaultMaxSongHistory;
    _youtubeApiSettings = _defaultYoutubeApiSettings;
  }

  @override
  String getLanguage() => _language ?? _defaultLanguage;

  @override
  int getMaxSongHistory() => _maxSongHistory ?? _defaultMaxSongHistory;

  @override
  YoutubeApiSettings getYoutubeApiSettings() =>
      _youtubeApiSettings ?? _defaultYoutubeApiSettings;

  @override
  Future<void> setLanguage(String? language) async {
    _language = language ?? _defaultLanguage;
  }

  @override
  Future<void> setMaxSongHistory(int? maxHistory) async {
    _maxSongHistory = maxHistory ?? _defaultMaxSongHistory;
    _onMaxSongHistoryChanged();
  }

  @override
  Future<void> setYoutubeApiSettings(YoutubeApiSettings? settings) async {
    _youtubeApiSettings = settings ?? _defaultYoutubeApiSettings;
    _onYoutubeSettingsChanged();
  }
}

class UserSettings extends DefaultSettings {
  late SharedPreferences preferences;

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
    _language = preferences.getString('language');
    _maxSongHistory = preferences.getInt('maxSongHistory');
    _youtubeApiSettings = YoutubeApiSettings(
      url: preferences.getString('youtubeApiUrl'),
      maxPing: preferences.getInt('youtubeApiMaxPing'),
    );
  }

  Future<void> _setString(String key, String? value) async {
    if (value == null) {
      if (preferences.containsKey(key)) {
        await preferences.remove(key);
      }
    } else {
      await preferences.setString(key, value);
    }
  }

  Future<void> _setInt(String key, int? value) async {
    if (value == null) {
      if (preferences.containsKey(key)) {
        await preferences.remove(key);
      }
    } else {
      await preferences.setInt(key, value);
    }
  }

  @override
  Future<void> setLanguage(String? language) {
    super.setLanguage(language);
    return _setString('language', language);
  }

  @override
  Future<void> setMaxSongHistory(int? maxHistory) {
    super.setMaxSongHistory(maxHistory);
    return _setInt('maxSongHistory', maxHistory);
  }

  @override
  Future<void> setYoutubeApiSettings(YoutubeApiSettings? settings) async {
    super.setYoutubeApiSettings(settings);
    await _setString('youtubeApiUrl', settings?.url);
    await _setInt('youtubeApiMaxPing', settings?.maxPing);
  }
}
