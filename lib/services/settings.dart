import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:http/http.dart' as http;

abstract class Settings {
  final List<Function(int)> _maxSongHistoryListeners = [];
  final List<Function(String)> _youtubeApiUrlListeners = [];

  void addMaxSongHistoryListener(Function(int) event) {
    _maxSongHistoryListeners.add(event);
  }

  void removeMaxSongHistoryListener(Function(int) event) {
    _maxSongHistoryListeners.remove(event);
  }

  void addYoutubeApiUrlListener(Function(String) event) {
    _youtubeApiUrlListeners.add(event);
  }

  void removeYoutubeApiUrlListener(Function(String) event) {
    _youtubeApiUrlListeners.remove(event);
  }

  void _onMaxSongHistoryChanged() {
    for (var listener in _maxSongHistoryListeners) {
      listener(getMaxSongHistory());
    }
  }

  void _onYoutubeApiUrlChanged() {
    for (var listener in _youtubeApiUrlListeners) {
      listener(getYoutubeApiUrl());
    }
  }

  String getLanguage();
  Future<void> setLanguage(String? language);

  int getMaxSongHistory();
  Future<void> setMaxSongHistory(int? maxHistory);

  String getYoutubeApiUrl();
  Future<void> setYoutubeApiUrl(String? apiUrl);

  int getYoutubeApiMaxPing();
  Future<void> setYoutubeApiMaxPing(int? maxPing);
}

class DefaultSettings extends Settings {
  static const String _defaultLanguage = 'en';
  static const int _defaultMaxSongHistory = 25;
  static const int _defaultYoutubeApiMaxPing = 50;

  String? _language;
  int? _maxSongHistory;
  String? _youtubeApiUrl;
  int? _youtubeApiMaxPing;

  DefaultSettings() {
    _language = _defaultLanguage;
    _maxSongHistory = _defaultMaxSongHistory;
    _youtubeApiMaxPing = _defaultYoutubeApiMaxPing;
  }

  @override
  String getLanguage() => _language ?? _defaultLanguage;

  @override
  int getMaxSongHistory() => _maxSongHistory ?? _defaultMaxSongHistory;

  @override
  String getYoutubeApiUrl() {
    if (_youtubeApiUrl == null) {
      throw Exception('Youtube API URL is not set');
    }
    return _youtubeApiUrl!;
  }

  @override
  int getYoutubeApiMaxPing() => _youtubeApiMaxPing ?? _defaultYoutubeApiMaxPing;

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
  Future<void> setYoutubeApiUrl(String? apiUrl) async {
    _youtubeApiUrl = apiUrl;
    _onYoutubeApiUrlChanged();
  }

  @override
  Future<void> setYoutubeApiMaxPing(int? maxPing) async {
    _youtubeApiMaxPing = maxPing ?? _defaultYoutubeApiMaxPing;
  }
}

class UserSettings extends DefaultSettings {
  static const String _youtubeApisProvider =
      'https://api.invidious.io/instances.json?sort_by=health';

  late SharedPreferences preferences;

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
    _language = preferences.getString('language');
    _maxSongHistory = preferences.getInt('maxSongHistory');
    _youtubeApiUrl = preferences.getString('youtubeApiUrl');
    _youtubeApiMaxPing = preferences.getInt('youtubeApiMaxPing');
    _youtubeApiUrl ??= await _getValidYoutubeApiUrl();
  }

  Future<String> _getValidYoutubeApiUrl() async {
    final response = await http.get(Uri.parse(_youtubeApisProvider));

    if (response.statusCode != 200) {
      throw Exception('Can not retreive YouTube APIS');
    }

    var list = jsonDecode(response.body) as List;
    var apis = list
        .where((e) =>
            e[1]['type'] == 'https' &&
            e[1]['api'] == true &&
            e[1]['stats'] != null &&
            e[1]['monitor'] != null &&
            e[1]['monitor']['statusClass'] == 'success')
        .toList();

    int timeout = 1;
    String? bestUrl;
    Duration bestPing = Duration(seconds: timeout);
    final max = Duration(milliseconds: getYoutubeApiMaxPing());
    for (int i = 0; i < apis.length; i++) {
      final api = apis[i][0];
      final ping = Ping(api, timeout: timeout);
      final first = await ping.stream.first;
      if (first.response?.time != null) {
        Duration time = first.response?.time as Duration;
        if (time < max) {
          return api;
        }
        if (time < bestPing) {
          bestPing = time;
          bestUrl = api;
        }
      }
    }

    if (bestUrl != null) {
      return bestUrl;
    }

    throw Exception('Valid YouTube API not found');
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
  Future<void> setYoutubeApiUrl(String? apiUrl) async {
    apiUrl ??= await _getValidYoutubeApiUrl();
    super.setYoutubeApiUrl(apiUrl);
    await _setString('youtubeApiUrl', apiUrl);
  }

  @override
  Future<void> setYoutubeApiMaxPing(int? maxPing) async {
    super.setYoutubeApiMaxPing(maxPing);
    await _setInt('youtubeApiMaxPing', maxPing);
    await setYoutubeApiUrl(null);
  }
}
