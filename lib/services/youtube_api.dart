import 'dart:convert';
import 'dart:typed_data';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:joetube/services/settings.dart';

import '../models/channel_model.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';

abstract class YouTubeApi {
  Future<List<Song>> searchSongs(String query, {int page = 1});
  Future<List<Channel>> searchChannel(String query, {int page = 1});
  Future<List<Playlist>> searchPlaylist(String query, {int page = 1});
  Future<Song> getSong(String id);
  Future<Channel> getChannel(String id);
  Future<Playlist> getPlaylist(String id);
  Future<List<Song>> getPlaylistSongs(String id);
  Future<List<Song>> getChannelSongs(String id);
  Future<List<Playlist>> getChannelPlaylists(String id);
  Future<List<Song>> getTrendingMusic(String region);
}

class InvidiousApi implements YouTubeApi {
  static const String _invidiousApisProvider =
      'https://api.invidious.io/instances.json?sort_by=health';

  static bool _isValid(String url) {
    return Uri.tryParse(url) != null;
  }

  static String _validate(String url) {
    if (!_isValid(url)) {
      throw Exception('Invalid YouTube API URL');
    }
    return url;
  }

  static dynamic _decode(Uint8List bytes) {
    return json.decode(utf8.decode(bytes).replaceAll('\\n', '\\\\n'));
  }

  static Future<String> _getValidYoutubeApiUrl(int maxPing) async {
    final response = await http.get(Uri.parse(_invidiousApisProvider));

    if (response.statusCode != 200) {
      throw Exception('Can not retreive Invidious APIS');
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
    final max = Duration(milliseconds: maxPing);
    for (int i = 0; i < apis.length; i++) {
      final api = apis[i][0];
      final ping = Ping(api, timeout: timeout);
      final first = await ping.stream.first;
      if (first.response?.time != null) {
        Duration time = first.response?.time as Duration;
        if (time < max) {
          return 'https://$api';
        }
        if (time < bestPing) {
          bestPing = time;
          bestUrl = api;
        }
      }
    }

    if (bestUrl != null) {
      return 'https://$bestUrl';
    }

    throw Exception('Valid Invidious API not found');
  }

  static Future<InvidiousApi> create(YoutubeApiSettings settings) async {
    String url =
        settings.url ?? await _getValidYoutubeApiUrl(settings.maxPing ?? 0);
    return InvidiousApi._(url);
  }

  InvidiousApi._(String url) {
    _url = _validate(url);
  }

  late String _url;
  String get url => _url;
  set url(String url) => _url = _validate(url);
  Future<void> searchApiUrl(YoutubeApiSettings settings) async {
    String url =
        settings.url ?? await _getValidYoutubeApiUrl(settings.maxPing ?? 0);
    _url = _validate(url);
  }

  @override
  Future<List<Song>> searchSongs(String query, {int page = 1}) async {
    final response = await http.get(Uri.parse(
        '$url/api/v1/search?q=$query&type=video&page=$page&premium=false&liveNow=false&isUpcoming=false'));

    if (response.statusCode != 200) {
      throw Exception('Song search failed');
    }

    var songs = _decode(response.bodyBytes) as List;
    return songs.map((s) => Song.fromApi(s)).toList();
  }

  @override
  Future<List<Channel>> searchChannel(String query, {int page = 1}) async {
    final response = await http
        .get(Uri.parse('$url/api/v1/search?q=$query&type=channel&page=$page'));

    if (response.statusCode != 200) {
      throw Exception('Channel search failed');
    }

    var channels = _decode(response.bodyBytes) as List;
    return channels.map((c) => Channel.fromApi(c)).toList();
  }

  @override
  Future<List<Playlist>> searchPlaylist(String query, {int page = 1}) async {
    final response = await http
        .get(Uri.parse('$url/api/v1/search?q=$query&type=playlist&page=$page'));

    if (response.statusCode != 200) {
      throw Exception('Playlist search failed');
    }

    var playlists = _decode(response.bodyBytes) as List;
    //var playlists = json.decode(response.body) as List;
    return playlists.map((c) => Playlist.fromApi(c)).toList();
  }

  @override
  Future<Song> getSong(String id) async {
    final response = await http.get(Uri.parse('$url/api/v1/videos/$id'));

    if (response.statusCode != 200) {
      throw Exception('Song get failed');
    }

    return Song.fromApi(_decode(response.bodyBytes));
  }

  @override
  Future<Playlist> getPlaylist(String id) async {
    final response = await http.get(Uri.parse('$url/api/v1/playlists/$id'));

    if (response.statusCode != 200) {
      throw Exception('Playlist get failed');
    }

    return Playlist.fromApi(_decode(response.bodyBytes));
  }

  @override
  Future<Channel> getChannel(String id) async {
    final response = await http.get(Uri.parse('$url/api/v1/channels/$id'));

    if (response.statusCode != 200) {
      throw Exception('Channel get failed');
    }

    return Channel.fromApi(_decode(response.bodyBytes));
  }

  @override
  Future<List<Song>> getPlaylistSongs(String id) async {
    final response = await http.get(Uri.parse('$url/api/v1/playlists/$id/'));

    if (response.statusCode != 200) {
      throw Exception('Playlist songs get failed');
    }

    var songs = _decode(response.bodyBytes)['videos'] as List;
    return songs.map((s) => Song.fromApi(s)).toList();
  }

  @override
  Future<List<Song>> getChannelSongs(String id) async {
    final response =
        await http.get(Uri.parse('$url/api/v1/channels/$id/videos/'));

    if (response.statusCode != 200) {
      throw Exception('Channel songs get failed');
    }

    var songs = _decode(response.bodyBytes)['videos'] as List;
    return songs.map((s) => Song.fromApi(s)).toList();
  }

  @override
  Future<List<Playlist>> getChannelPlaylists(String id) async {
    final response =
        await http.get(Uri.parse('$url/api/v1/channels/$id/playlists/'));

    if (response.statusCode != 200) {
      throw Exception('Channel playlist get failed');
    }

    var playlists = _decode(response.bodyBytes)['playlists'] as List;
    return playlists.map((c) => Playlist.fromApi(c)).toList();
  }

  @override
  Future<List<Song>> getTrendingMusic(String region) async {
    final response = await http.get(
        Uri.parse('$url/api/v1/trending?type=Music&region=$region&type=video'));

    if (response.statusCode != 200) {
      throw Exception('Trending get failed');
    }

    var songs = _decode(response.bodyBytes) as List;
    return songs.map((s) => Song.fromApi(s)).toList();
  }
}
